import 'package:eaqarati_app/core/utils/enum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:eaqarati_app/core/utils/constants.dart';
import 'package:eaqarati_app/features/domain/entities/property_entity.dart';
import 'package:eaqarati_app/features/presentation/blocs/property/property_bloc.dart';
import 'package:eaqarati_app/features/presentation/blocs/units/units_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

// You might want a dedicated loading widget for list items
class PropertyListItemShimmer extends StatelessWidget {
  const PropertyListItemShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.only(bottom: kVerticalSpaceMedium),
      padding: const EdgeInsets.all(kPagePadding / 1.5),
      decoration: BoxDecoration(
        color: colorScheme.surfaceVariant.withOpacity(0.3),
        borderRadius: BorderRadius.circular(16),
      ),
      height: 80, // Approximate height of a list item
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            color: colorScheme.onSurfaceVariant.withOpacity(0.1),
          ),
          const SizedBox(width: kVerticalSpaceMedium),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.4,
                  height: 16,
                  color: colorScheme.onSurfaceVariant.withOpacity(0.1),
                ),
                const SizedBox(height: kVerticalSpaceSmall / 2),
                Container(
                  width: MediaQuery.of(context).size.width * 0.3,
                  height: 12,
                  color: colorScheme.onSurfaceVariant.withOpacity(0.1),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PropertiesScreen extends HookWidget {
  const PropertiesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    final animationController = useAnimationController(
      duration: const Duration(milliseconds: 700),
    );

    useEffect(() {
      context.read<PropertyBloc>().add(LoadAllProperties());
      animationController.forward();
      return null;
    }, const []);

    // For the FAB animation
    final fabScaleController = useAnimationController(
      duration: const Duration(milliseconds: 300),
    );
    final fabScaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: fabScaleController, curve: Curves.elasticOut),
    );
    useEffect(() {
      Future.delayed(const Duration(milliseconds: 500), () {
        // Delay FAB animation
        if (context.mounted) fabScaleController.forward();
      });
      return fabScaleController.dispose;
    }, const []);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: _buildAppBar(context, textTheme, colorScheme),
      body: BlocBuilder<PropertyBloc, PropertyState>(
        builder: (context, state) {
          Widget bodyContent;

          if (state is PropertyLoading && state is! PropertiesLoaded) {
            bodyContent = ListView.builder(
              padding: const EdgeInsets.all(kPagePadding),
              itemCount: 5,
              itemBuilder: (ctx, idx) => const PropertyListItemShimmer(),
            );
          } else if (state is PropertiesLoaded) {
            if (state.properties.isEmpty) {
              bodyContent = Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.villa_outlined,
                      size: 80,
                      color: colorScheme.onSurface.withOpacity(0.5),
                    ),
                    const SizedBox(height: kVerticalSpaceMedium),
                    Text(
                      'propertiesScreen.properties_title'.tr(),
                      style: textTheme.titleLarge?.copyWith(
                        color: colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: kVerticalSpaceSmall),
                    Text(
                      'propertiesScreen.properties_subtitle'.tr(),
                      style: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurface,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: kVerticalSpaceMedium * 2),
                    Center(
                      child: Text(
                        'propertiesScreen.no_properties'.tr(),
                        style: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ),
                    // ElevatedButton.icon(
                    //   icon: const Icon(Icons.add_rounded),
                    //   label: Text('propertiesScreen.add_first_property'.tr()),
                    //   onPressed: () {
                    //     // TODO: Navigate to Add Property Screen
                    //     // context.go('/add-property');
                    //   },
                    //   style: ElevatedButton.styleFrom(
                    //     backgroundColor: colorScheme.primary,
                    //     foregroundColor: colorScheme.onPrimary,
                    //     padding: const EdgeInsets.symmetric(
                    //       horizontal: 24,
                    //       vertical: 12,
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              );
            } else {
              bodyContent = RefreshIndicator(
                onRefresh: () async {
                  context.read<PropertyBloc>().add(LoadAllProperties());
                },
                child: CustomScrollView(
                  slivers: [
                    SliverPadding(
                      padding: const EdgeInsets.all(kPagePadding),
                      sliver: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'propertiesScreen.properties_title'.tr(),
                            style: textTheme.titleLarge?.copyWith(
                              color: colorScheme.onSurface,
                            ),
                          ),
                          const SizedBox(height: kVerticalSpaceSmall),
                          Text(
                            'propertiesScreen.properties_subtitle'.tr(),
                            style: textTheme.bodyMedium?.copyWith(
                              color: colorScheme.secondary,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: kVerticalSpaceMedium * 2),
                        ],
                      ),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.all(kPagePadding),
                      sliver: SliverList(
                        delegate: SliverChildListDelegate([
                          _buildTotalPropertiesCard(
                            context,
                            state.properties.length,
                            animationController,
                          ),
                          const SizedBox(height: kVerticalSpaceMedium * 1.5),
                        ]),
                      ),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: kPagePadding,
                      ),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate((context, index) {
                          final property = state.properties[index];
                          final itemAnimation = Tween<double>(
                            begin: 0.0,
                            end: 1.0,
                          ).animate(
                            CurvedAnimation(
                              parent: animationController,
                              curve: Interval(
                                (0.3 +
                                        (0.7 *
                                            (index / state.properties.length)))
                                    .clamp(0.0, 1.0),
                                1.0,
                                curve: Curves.easeOutCubic,
                              ),
                            ),
                          );
                          return AnimatedBuilder(
                            animation: itemAnimation,
                            builder:
                                (context, child) => Opacity(
                                  opacity: itemAnimation.value,
                                  child: Transform.translate(
                                    offset: Offset(
                                      0,
                                      30 * (1 - itemAnimation.value),
                                    ),
                                    child: child,
                                  ),
                                ),
                            child: _PropertyListItem(property: property),
                          );
                        }, childCount: state.properties.length),
                      ),
                    ),
                    const SliverToBoxAdapter(
                      child: SizedBox(height: kPagePadding * 3),
                    ), // Space for FAB
                  ],
                ),
              );
            }
          } else if (state is PropertyError) {
            bodyContent = Center(child: Text('Error: ${state.message}'));
          } else {
            bodyContent = const Center(
              child: CircularProgressIndicator(),
            ); // Initial or unexpected state
          }

          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: bodyContent,
          );
        },
      ),
      floatingActionButton: ScaleTransition(
        scale: fabScaleAnimation,
        child: FloatingActionButton(
          onPressed: () {
            // TODO: Navigate to Add Property Screen
            // context.go('/add-property');
          },
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          elevation: 4.0,
          child: const Icon(Icons.add_rounded, size: 28),
        ),
      ),
    );
  }

  AppBar _buildAppBar(
    BuildContext context,
    TextTheme textTheme,
    ColorScheme colorScheme,
  ) {
    return AppBar(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      elevation: 0,
      centerTitle: false,
      titleSpacing: kPagePadding,
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(kVerticalSpaceSmall),
            decoration: BoxDecoration(
              color: colorScheme.primary,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              'E', // First letter of "Eaqarati"
              style: textTheme.titleLarge?.copyWith(
                color: colorScheme.onPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: kVerticalSpaceSmall),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'app.name'.tr(), // "Eaqarati"
                style: textTheme.titleMedium?.copyWith(
                  color: colorScheme.onBackground,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'app.management_service'.tr(), // "Property Management"
                style: textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.search_rounded, color: colorScheme.onSurfaceVariant),
          onPressed: () {
            /* TODO: Implement search */
          },
        ),
        IconButton(
          icon: Icon(
            Icons.notifications_none_rounded,
            color: colorScheme.onSurfaceVariant,
          ),
          onPressed: () {
            /* TODO: Navigate to Notifications Screen */
          },
        ),
        const SizedBox(width: kPagePadding / 2),
      ],
    );
  }

  Widget _buildTotalPropertiesCard(
    BuildContext context,
    int totalCount,
    AnimationController animationController,
  ) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    final cardAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    return AnimatedBuilder(
      animation: cardAnimation,
      builder:
          (context, child) => Opacity(
            opacity: cardAnimation.value,
            child: Transform.translate(
              offset: Offset(0, 50 * (1 - cardAnimation.value)),
              child: child,
            ),
          ),
      child: Container(
        padding: const EdgeInsets.all(kPagePadding),
        decoration: BoxDecoration(
          color: colorScheme.primary,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: colorScheme.primary.withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'propertiesScreen.total_properties_card_title'.tr(),
                  style: textTheme.titleMedium?.copyWith(
                    color: colorScheme.onPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: kVerticalSpaceSmall / 2),
                Text(
                  totalCount.toString(),
                  style: textTheme.displaySmall?.copyWith(
                    color: colorScheme.onPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.all(kPagePadding / 1.5),
              decoration: BoxDecoration(
                color: colorScheme.onPrimary.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.business_rounded,
                size: 32,
                color: colorScheme.onPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PropertyListItem extends HookWidget {
  final PropertyEntity property;

  const _PropertyListItem({required this.property});

  IconData _getPropertyTypeIcon(PropertyType type) {
    if (type == PropertyType.apartment || type == PropertyType.building) {
      return Icons.apartment_rounded;
    } else if (type == PropertyType.chalet || type == PropertyType.villa) {
      return Icons.villa_rounded;
    } else if (type == PropertyType.office) {
      return Icons.workspaces_outline;
    } else if (type == PropertyType.residential_complex) {
      return Icons.holiday_village_outlined;
    }
    return Icons.location_city_rounded;
  }

  Color _getPropertyIconBackgroundColor(
    PropertyType type,
    ColorScheme colorScheme,
  ) {
    if (type == PropertyType.apartment || type == PropertyType.building) {
      return Colors.blue.shade50;
    } else if (type == PropertyType.chalet || type == PropertyType.villa) {
      return Colors.green.shade50;
    } else if (type == PropertyType.office) {
      return Colors.orange.shade50;
    } else if (type == PropertyType.residential_complex) {
      return Colors.purple.shade50;
    }
    return colorScheme.primaryContainer.withOpacity(0.1);
  }

  Color _getPropertyIconColor(PropertyType type, ColorScheme colorScheme) {
    if (type == PropertyType.apartment || type == PropertyType.building) {
      return Colors.blue.shade700;
    } else if (type == PropertyType.chalet || type == PropertyType.villa) {
      return Colors.green.shade700;
    } else if (type == PropertyType.office) {
      return Colors.orange.shade700;
    } else if (type == PropertyType.residential_complex) {
      return Colors.purple.shade700;
    }
    return colorScheme.primary;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    useEffect(() {
      if (property.propertyId != null) {
        context.read<UnitsBloc>().add(
          LoadUnitsByPropertyId(property.propertyId!),
        );
      }
      return null;
    }, [property.propertyId]);

    return Card(
      elevation: 0.5,
      shadowColor: colorScheme.shadow.withOpacity(0.1),
      margin: const EdgeInsets.only(bottom: kVerticalSpaceMedium),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: colorScheme.surface,
      child: InkWell(
        onTap: () {
          // TODO: Navigate to Property Details Screen, pass property.propertyId
          // context.go('/property-details/${property.propertyId}');
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(kPagePadding / 1.5),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(kVerticalSpaceMedium * 0.75),
                decoration: BoxDecoration(
                  color: _getPropertyIconBackgroundColor(
                    property.type,
                    colorScheme,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  _getPropertyTypeIcon(property.type),
                  color: _getPropertyIconColor(property.type, colorScheme),
                  size: 24,
                ),
              ),
              const SizedBox(width: kVerticalSpaceMedium),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      property.name,
                      style: textTheme.titleSmall?.copyWith(
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: kVerticalSpaceSmall / 3),
                    Text(
                      property.type
                          .toString(), // Or a localized version of type
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: kVerticalSpaceSmall / 3),
                    BlocBuilder<UnitsBloc, UnitsState>(
                      // Listen to UnitsBloc for unit count
                      builder: (context, unitsState) {
                        int unitCount = 0;
                        if (unitsState is UnitsLoaded) {
                          unitCount =
                              unitsState.units
                                  .where(
                                    (u) => u.propertyId == property.propertyId,
                                  )
                                  .length;
                        }
                        return Row(
                          children: [
                            Icon(
                              Icons.meeting_room_outlined,
                              size: 14,
                              color: colorScheme.onSurfaceVariant.withOpacity(
                                0.7,
                              ),
                            ),
                            const SizedBox(width: kVerticalSpaceSmall / 2),
                            Text(
                              'propertiesScreen.units_count'.tr(
                                args: [unitCount.toString()],
                              ),
                              style: textTheme.bodySmall?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16,
                color: colorScheme.onSurfaceVariant.withOpacity(0.7),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
