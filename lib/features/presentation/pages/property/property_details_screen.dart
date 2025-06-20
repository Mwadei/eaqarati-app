import 'package:eaqarati_app/core/utils/constants.dart';
import 'package:eaqarati_app/core/utils/enum.dart';
import 'package:eaqarati_app/features/domain/entities/property_entity.dart';
import 'package:eaqarati_app/features/presentation/blocs/property/property_bloc.dart';
import 'package:eaqarati_app/features/presentation/blocs/units/units_bloc.dart';
import 'package:eaqarati_app/features/presentation/widgets/property_details_shimmer.dart';
import 'package:eaqarati_app/features/presentation/widgets/unit_item_shimmer.dart';
import 'package:eaqarati_app/features/presentation/widgets/unit_list_item.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';

class PropertyDetailsScreen extends HookWidget {
  final int propertyId;
  const PropertyDetailsScreen({super.key, required this.propertyId});

  void _handleMenuAction(
    BuildContext context,
    DetailsMenuAction actions,
    PropertyEntity property,
  ) async {
    switch (actions) {
      case DetailsMenuAction.delete:
        _confirmDeleteProperty(context, property);
        break;
      case DetailsMenuAction.edit:
        // Navigate to Edit Unit Screen
        // Example: context.pushNamed('unitForm', extra: unit, pathParameters: {'propertyId': propertyId.toString()});
        final result = await await context.pushNamed(
          'propertyForm',
          extra: property,
        );

        if (result == true && context.mounted) {
          context.read<PropertyBloc>().add(LoadPropertyById(propertyId));
          context.read<UnitsBloc>().add(LoadUnitsByPropertyId(propertyId));
        }
        break;
      default:
    }
  }

  Future<void> _confirmDeleteProperty(
    BuildContext context,
    PropertyEntity property,
  ) async {
    final bool? isConfirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('property_details.delete_property_confirm_title'.tr()),
          content: Text(
            'property_details.delete_property_confirm_message'.tr(
              namedArgs: {'propertyName': property.name},
            ),
          ),
          actions: [
            TextButton(
              child: Text('common.cancel'.tr()),
              onPressed: () {
                context.pop(false);
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.error,
              ),
              child: Text('common.delete'.tr()),
              onPressed: () {
                context.pop(true);
              },
            ),
          ],
        );
      },
    );

    if (isConfirmed == true && property.propertyId != null) {
      // ignore: use_build_context_synchronously
      context.read<PropertyBloc>().add(DeleteExistingProperty(propertyId));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    final overallAnimationController = useAnimationController(
      duration: const Duration(milliseconds: 600),
    );
    final listAnimationController = useAnimationController(
      duration: const Duration(milliseconds: 500),
    );

    useEffect(() {
      context.read<PropertyBloc>().add(LoadPropertyById(propertyId));
      context.read<UnitsBloc>().add(LoadUnitsByPropertyId(propertyId));
      overallAnimationController.forward();
      return null;
    }, [propertyId]);

    final propertyState = context.watch<PropertyBloc>().state;
    final unitsState = context.watch<UnitsBloc>().state;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colorScheme.onSurface),
          onPressed: () {
            context.pop();
          },
        ),
        title: Text(
          'property_details.title'.tr(),
          style: textTheme.titleLarge?.copyWith(color: colorScheme.onSurface),
        ),
        centerTitle: true,
        actions: [
          if (propertyState is PropertyLoaded)
            PopupMenuButton<DetailsMenuAction>(
              icon: Icon(Icons.more_vert, color: colorScheme.onSurface),
              onSelected:
                  (action) => _handleMenuAction(
                    context,
                    action,
                    propertyState.property,
                  ),
              itemBuilder:
                  (context) => [
                    PopupMenuItem(
                      value: DetailsMenuAction.edit,
                      child: ListTile(
                        leading: Icon(
                          Icons.edit_outlined,
                          color: colorScheme.onSurfaceVariant,
                        ),
                        title: Text('common.edit'.tr()),
                      ),
                    ),
                    const PopupMenuDivider(),
                    PopupMenuItem(
                      value: DetailsMenuAction.delete,
                      child: ListTile(
                        leading: Icon(
                          Icons.delete_outline,
                          color: colorScheme.error,
                        ),
                        title: Text(
                          'common.delete'.tr(),
                          style: TextStyle(color: colorScheme.error),
                        ),
                      ),
                    ),
                  ],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(kVerticalSpaceSmall),
              ),
            ),

          const SizedBox(
            width: kPagePadding / 2 - 10,
          ), // Adjust padding slightly if needed
        ],
      ),
      body: BlocListener<PropertyBloc, PropertyState>(
        listener: (context, state) {
          if (state is PropertyDeleteSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('property_details.delete_property_success'.tr()),
                backgroundColor: Colors.green,
                duration: const Duration(seconds: 1),
              ),
            );
            if (context.canPop()) {
              context.pop(true);
            }
          } else if (state is PropertyError &&
              ModalRoute.of(context)?.isCurrent == true) {
            // Show error only if this screen is still active, to avoid showing on previous screen
            final previousState = context.read<PropertyBloc>().state;
            // A simple way to check if the error is related to a delete operation (could be more specific)
            if (previousState is PropertyLoading) {
              // Assuming delete sets loading state
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('unit_details.delete_unit_error'.tr()),
                  backgroundColor: Theme.of(context).colorScheme.error,
                ),
              );
            }
          }
        },
        child: BlocBuilder<PropertyBloc, PropertyState>(
          builder: (context, pState) {
            if (pState is PropertyLoading ||
                (pState is PropertyInitial && unitsState is UnitsLoading)) {
              return const PropertyDetailsShimmer();
            } else if (pState is PropertyLoaded) {
              final property = pState.property;
              // Trigger list animation when units are loaded after property
              if (unitsState is UnitsLoaded &&
                  !listAnimationController.isAnimating &&
                  !listAnimationController.isCompleted) {
                listAnimationController.forward();
              }
              return FadeTransition(
                opacity: CurvedAnimation(
                  parent: overallAnimationController,
                  curve: Curves.easeIn,
                ),
                child: CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(
                          kPagePadding,
                          kPagePadding,
                          kPagePadding,
                          0,
                        ),
                        child: _buildPropertyInfoCard(context, property),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(
                          kPagePadding,
                          kVerticalSpaceMedium * 1.5,
                          kPagePadding,
                          kVerticalSpaceSmall,
                        ),
                        child: _buildUnitsHeader(context, unitsState),
                      ),
                    ),
                    _buildUnitsList(
                      context,
                      unitsState,
                      listAnimationController,
                      property.type,
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(
                          kPagePadding,
                        ).copyWith(top: kVerticalSpaceMedium * 1.5),
                        child: _buildActionButtons(context, property),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: SizedBox(
                        height:
                            MediaQuery.of(context).padding.bottom +
                            kVerticalSpaceMedium,
                      ),
                    ),
                  ],
                ),
              );
            } else if (pState is PropertyError) {
              return Center(
                child: Text(
                  'property_details.error_loading_property'.tr(
                    args: [pState.message],
                  ),
                ),
              );
            }
            return const PropertyDetailsShimmer();
          },
        ),
      ),
    );
  }

  Widget _buildPropertyInfoCard(BuildContext context, PropertyEntity property) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    String propertyTypeDisplay = property.type.name;
    try {
      propertyTypeDisplay =
          'add_edit_property_screen.propertyType_${property.type.name}'.tr();
    } catch (e) {
      // If translation key not found, use a sensible default
      propertyTypeDisplay =
          property.type.name
              .replaceAllMapped(
                RegExp(r'([A-Z])'),
                (match) => ' ${match.group(1)}',
              )
              .trim();
      propertyTypeDisplay =
          propertyTypeDisplay[0].toUpperCase() +
          propertyTypeDisplay.substring(1);
    }

    return Card(
      elevation: 1,
      shadowColor: colorScheme.shadow.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.all(kPagePadding / 1.5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        property.name,
                        style: textTheme.titleLarge?.copyWith(
                          color: colorScheme.onPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: kVerticalSpaceMedium),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: getPropertyIconBackgroundColor(
                      property.type,
                      colorScheme,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    getPropertyTypeIcon(property.type),
                    color: getPropertyIconColor(property.type, colorScheme),
                    size: 30,
                  ),
                ),
              ],
            ),
            const SizedBox(height: kVerticalSpaceMedium * 1.5),
            _buildInfoRow(
              context,
              icon: Icons.location_on_outlined,
              text: property.address ?? 'property_details.no_address'.tr(),
            ),
            const SizedBox(height: kVerticalSpaceSmall * 1.25),
            _buildInfoRow(
              context,
              icon: Icons.home_work_outlined,
              text: propertyTypeDisplay,
            ),
            const SizedBox(height: kVerticalSpaceSmall * 1.25),
            _buildInfoRow(
              context,
              icon: Icons.notes_rounded,
              text: property.notes ?? 'property_details.no_description'.tr(),
              maxLines: 5,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context, {
    required IconData icon,
    required String text,
    int maxLines = 2,
  }) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: colorScheme.onSurfaceVariant, size: 20),
        const SizedBox(width: kVerticalSpaceMedium * 0.75),
        Expanded(
          child: Text(
            text,
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
            maxLines: maxLines,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildUnitsHeader(BuildContext context, UnitsState unitsState) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    int unitCount = 0;
    if (unitsState is UnitsLoaded) {
      unitCount = unitsState.units.length;
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'property_details.units_title'.tr(),
          style: textTheme.titleLarge?.copyWith(
            color: theme.colorScheme.onPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        if (unitCount > 0 || unitsState is UnitsLoading)
          Chip(
            label: Text(
              'property_details.total_units'.tr(
                args: [
                  unitsState is UnitsLoading ? "..." : unitCount.toString(),
                ],
              ),
            ),
            backgroundColor: theme.primaryColor.withOpacity(0.7),
            labelStyle: textTheme.bodySmall?.copyWith(
              color: theme.primaryColor,
              fontWeight: FontWeight.bold,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
      ],
    );
  }

  Widget _buildUnitsList(
    BuildContext context,
    UnitsState unitsState,
    AnimationController listAnimationController,
    PropertyType propertyType,
  ) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    if (unitsState is UnitsLoading) {
      return SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: kPagePadding),
            child: const UnitItemShimmer(),
          ),
          childCount: 3,
        ),
      );
    } else if (unitsState is UnitsLoaded) {
      if (unitsState.units.isEmpty) {
        return SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: kPagePadding * 2,
              horizontal: kPagePadding,
            ),
            child: Center(
              child: Text(
                'property_details.no_units_found'.tr(),
                style: textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        );
      }
      return SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: kPagePadding),
        sliver: SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            final unit = unitsState.units[index];
            final itemAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
              CurvedAnimation(
                parent: listAnimationController,
                curve: Interval(
                  (0.2 * index / unitsState.units.length).clamp(0.0, 1.0),
                  (1.0).clamp(0.0, 1.0),
                  curve: Curves.easeOutCubic,
                ),
              ),
            );
            return UnitListItem(
              unit: unit,
              propertyType: propertyType,
              animation: itemAnimation,
            );
          }, childCount: unitsState.units.length),
        ),
      );
    } else if (unitsState is UnitError) {
      return SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.all(kPagePadding),
          child: Center(
            child: Text(
              'property_details.no_units_found'.tr(args: [unitsState.message]),
            ),
          ),
        ),
      );
    }
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: kPagePadding),
          child: const UnitItemShimmer(),
        ),
        childCount: 3,
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, PropertyEntity property) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            icon: const Icon(Icons.edit_outlined),
            label: Text('property_details.edit_property_button'.tr()),
            onPressed: () async {
              final result = await context.pushNamed(
                'propertyForm',
                extra: property,
              );
              if (result == true) {
                if (context.mounted) {
                  context.read<PropertyBloc>().add(
                    LoadPropertyById(propertyId),
                  );
                  context.read<UnitsBloc>().add(
                    LoadUnitsByPropertyId(propertyId),
                  );
                }
              }
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: theme.primaryColor,
              side: BorderSide(color: theme.primaryColor, width: 1.5),
              padding: const EdgeInsets.symmetric(vertical: 14),
              textStyle: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        const SizedBox(width: kVerticalSpaceSmall * 1.5),
        Expanded(
          child: ElevatedButton.icon(
            icon: const Icon(
              Icons.add_circle_outline_rounded,
              color: Colors.white,
            ),
            label: Text('property_details.add_unit_button'.tr()),
            onPressed: () {
              // TODO: Navigate to Add Unit Screen
              // Example: context.pushNamed('unitForm', pathParameters: {'propertyId': property.propertyId.toString()});
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('property_details.add_unit_todo'.tr())),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              textStyle: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
