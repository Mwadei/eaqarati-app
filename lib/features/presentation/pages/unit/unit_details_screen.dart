import 'package:eaqarati_app/core/utils/constants.dart';
import 'package:eaqarati_app/core/utils/enum.dart';
import 'package:eaqarati_app/features/domain/entities/lease_entity.dart';
import 'package:eaqarati_app/features/domain/entities/units_entity.dart';
import 'package:eaqarati_app/features/presentation/blocs/lease/lease_bloc.dart';
import 'package:eaqarati_app/features/presentation/blocs/tenant/tenant_bloc.dart';
import 'package:eaqarati_app/features/presentation/blocs/units/units_bloc.dart';
import 'package:eaqarati_app/features/presentation/widgets/current_lease_card.dart';
import 'package:eaqarati_app/features/presentation/widgets/lease_card_shimmer.dart';
import 'package:eaqarati_app/features/presentation/widgets/unit_details_shimmer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';

class UnitDetailsScreen extends HookWidget {
  final PropertyType propertyType;
  final int unitId;

  const UnitDetailsScreen({
    super.key,
    required this.propertyType,
    required this.unitId,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    final animationController = useAnimationController(
      duration: const Duration(milliseconds: 600),
    );

    useEffect(() {
      context.read<UnitsBloc>().add(LoadUnitById(unitId));
      context.read<LeaseBloc>().add(LoadLeasesByUnitId(unitId));
      animationController.forward();
      return null;
    }, [unitId]);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: _buildAppBar(context, textTheme, colorScheme),
      body: MultiBlocListener(
        listeners: [
          BlocListener<LeaseBloc, LeaseState>(
            listener: (context, leaseState) {
              if (leaseState is LeasesLoaded) {
                final activeLease = leaseState.leases.firstWhere(
                  (l) => l.isActive,
                  orElse:
                      () => LeaseEntity(
                        unitId: -1,
                        tenantId: -1,
                        startDate: DateTime.now(),
                        endDate: DateTime.now(),
                        rentAmount: 0,
                        paymentFrequencyType: PaymentFrequencyType.monthly,
                        createdAt: DateTime.now(),
                      ),
                );
                if (activeLease.leaseId != null) {
                  context.read<TenantBloc>().add(
                    LoadTenantById(activeLease.tenantId),
                  );
                }
              }
            },
          ),
        ],
        child: BlocBuilder<UnitsBloc, UnitsState>(
          builder: (context, unitState) {
            if (unitState is UnitsLoading || unitState is UnitsInitial) {
              return const UnitDetailsShimmer();
            } else if (unitState is UnitLoaded) {
              return FadeTransition(
                opacity: CurvedAnimation(
                  parent: animationController,
                  curve: Curves.easeIn,
                ),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return SingleChildScrollView(
                      padding: const EdgeInsets.only(bottom: kPagePadding),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight:
                              constraints.maxHeight -
                              (kPagePadding + 50 + kPagePadding),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(kPagePadding),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildUnitInfoCard(context, unitState.unit),
                                  const SizedBox(
                                    height: kVerticalSpaceMedium * 1.5,
                                  ),
                                  // Lease card will be built based on LeaseBloc and TenantBloc states
                                  _buildLeaseSection(context),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  top: kVerticalSpaceMedium * 2,
                                ),
                                child: _buildActionButtons(
                                  context,
                                  unitState.unit,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            } else if (unitState is UnitError) {
              return Center(
                child: Text(
                  'unit_details.error_loading_unit'.tr(
                    args: [unitState.message],
                  ),
                ),
              );
            }
            return const Center(child: CircularProgressIndicator());
          },
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
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: colorScheme.onSurface),
        onPressed: () => context.pop(),
      ),
      centerTitle: false,
      titleSpacing: 0,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'unit_details.title'.tr(),
            style: textTheme.titleLarge?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            'unit_details.subtitle_app_name'.tr(),
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.more_vert, color: colorScheme.onSurfaceVariant),
          onPressed: () {
            // TODO: Implement more actions like delete
            // Example: Show a menu with delete option
          },
        ),
        const SizedBox(width: kPagePadding / 2),
      ],
    );
  }

  Widget _buildUnitInfoCard(BuildContext context, UnitsEntity unit) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    Color statusColor;
    Color statusTextColor;
    String statusText;

    switch (unit.status) {
      case UnitStatus.vacant:
        statusColor = const Color(0xFFDCFCE7).withOpacity(0.1); // Light Green
        statusTextColor = const Color(0xFF16A34A); // Dark Green
        statusText = 'units.status_vacant'.tr();
        break;
      case UnitStatus.occupied:
        statusColor = const Color(
          0xFFFFEFC3,
        ).withOpacity(0.1); // Light Yellow/Orange (from image for Occupied)
        statusTextColor = const Color(0xFFB45309); // Dark Yellow/Orange
        statusText = 'units.status_occupied'.tr();
        break;
      case UnitStatus.underMaintenance:
        statusColor = Colors.grey.withOpacity(0.1);
        statusTextColor = Colors.grey.shade700;
        statusText = 'units.status_maintenance'.tr();
        break;
    }

    // Assuming unit.description contains "Spacious 2-bedroom..." and "2BR/2BA" for type
    // This parsing is very basic, consider a more structured approach in your entity.
    String mainDescription =
        unit.description ?? 'unit_details.no_description'.tr();
    // String unitTypeDisplay = "N/A"; // Fallback for unit type
    // if (unit.description != null) {
    //   // Example: if description is "2BR/2BA | Spacious 2-bedroom..."
    //   // You might need a more robust way to get this, e.g. a separate field or better parsing.
    //   // For the image, it seems "2BR/2BA" is distinct.
    //   // Let's assume unit.description might be "Spacious...". We need a field for "2BR/2BA".
    //   // If not, we'll use a placeholder from description if it has "BR" or "BA".
    //   if (unit.description!.contains("BR") ||
    //       unit.description!.contains("BA")) {
    //     // This is a very naive way to extract type, ideally have a separate field
    //     final typeMatch = RegExp(
    //       r'(\d+BR/\d+BA|\d+BR|\d+BA)',
    //     ).firstMatch(unit.description!);
    //     if (typeMatch != null) {
    //       unitTypeDisplay = typeMatch.group(0)!;
    //     } else {
    //       unitTypeDisplay = "Info"; // Placeholder
    //     }
    //   }
    // }

    return Card(
      elevation: 1,
      shadowColor: colorScheme.shadow.withOpacity(0.08),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.all(kPagePadding / 1.25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Unit number
                    Text(
                      'units.unit_prefix'.tr(args: [unit.unitNumber]),
                      style: textTheme.headlineSmall?.copyWith(
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: kVerticalSpaceSmall / 2),
                    // Status
                    Chip(
                      label: Text(statusText),
                      backgroundColor: statusColor,
                      labelStyle: textTheme.labelMedium?.copyWith(
                        color: statusTextColor,
                        fontWeight: FontWeight.w600,
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 3,
                      ),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ],
                ),

                // Property type badge
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: getPropertyIconBackgroundColor(
                      propertyType,
                      colorScheme,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    getPropertyTypeIcon(propertyType),
                    color: getPropertyIconColor(propertyType, colorScheme),
                    size: 26,
                  ),
                ),
              ],
            ),
            const SizedBox(height: kVerticalSpaceMedium * 0.75),
            Text(
              mainDescription,
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
                height: 1.4,
              ),
            ),
            const SizedBox(height: kVerticalSpaceMedium * 1.25),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'unit_details.default_rent'.tr(),
                        style: textTheme.bodySmall?.copyWith(
                          color: kSecondaryTextColor,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${NumberFormat.currency(locale: context.locale.toString(), symbol: 'unit_details.currency'.tr(), decimalDigits: 0).format(unit.defaultRentAmount ?? 0)}/${'unit_details.rent_freq_month'.tr()}',
                        style: textTheme.titleMedium?.copyWith(
                          color: colorScheme.onSurface,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                // Expanded(
                //   child: Column(
                //     crossAxisAlignment: CrossAxisAlignment.start,
                //     children: [
                //       Text(
                //         'unit_details.unit_type'.tr(),
                //         style: textTheme.bodySmall?.copyWith(
                //           color: kSecondaryTextColor,
                //         ),
                //       ),
                //       const SizedBox(height: 2),
                //       Text(
                //         unitTypeDisplay, // e.g. 2BR/2BA, from unit.description or a new field
                //         style: textTheme.titleMedium?.copyWith(
                //           color: colorScheme.onSurface,
                //           fontWeight: FontWeight.bold,
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLeaseSection(BuildContext context) {
    return BlocBuilder<LeaseBloc, LeaseState>(
      builder: (context, leaseState) {
        if (leaseState is LeaseLoading) {
          return LeaseCardShimmer();
        }
        if (leaseState is LeasesLoaded) {
          final activeLease = leaseState.leases.firstWhere(
            (l) =>
                l.isActive &&
                l.unitId == unitId, // ensure it's for the current unit
            orElse:
                () => LeaseEntity(
                  unitId: -1,
                  tenantId: -1,
                  startDate: DateTime.now(),
                  endDate: DateTime.now(),
                  rentAmount: 0,
                  paymentFrequencyType: PaymentFrequencyType.monthly,
                  createdAt: DateTime.now(),
                ),
          );

          if (activeLease.leaseId != null) {
            return BlocBuilder<TenantBloc, TenantState>(
              builder: (context, tenantState) {
                if (tenantState is TenantLoading && tenantState.props.isEmpty) {
                  return LeaseCardShimmer();
                }
                if (tenantState is TenantLoaded &&
                    tenantState.tenant.tenantId == activeLease.tenantId) {
                  return CurrentLeaseCard(
                    lease: activeLease,
                    tenant: tenantState.tenant,
                  );
                }
                return LeaseCardShimmer();
              },
            );
          }
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildActionButtons(BuildContext context, UnitsEntity unit) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            icon: Icon(Icons.edit_outlined, color: theme.primaryColor),
            label: Text('unit_details.edit_unit_button'.tr()),
            onPressed: () {
              // TODO: Navigate to Edit Unit Screen, pass unit
              // context.pushNamed('unitForm', extra: unit, pathParameters: {'propertyId': propertyId.toString()});
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: theme.primaryColor,
              backgroundColor: theme.colorScheme.surface,
              side: BorderSide(color: theme.dividerColor.withOpacity(0.5)),
              padding: const EdgeInsets.symmetric(vertical: 14),
              textStyle: textTheme.titleSmall?.copyWith(
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
          child: OutlinedButton.icon(
            icon: Icon(Icons.history_rounded, color: theme.primaryColor),
            label: Text('unit_details.unit_history_button'.tr()),
            onPressed: () {
              // TODO: Navigate to Unit History Screen
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: theme.primaryColor,
              backgroundColor: theme.colorScheme.surface,
              side: BorderSide(color: theme.dividerColor.withOpacity(0.5)),
              padding: const EdgeInsets.symmetric(vertical: 14),
              textStyle: textTheme.titleSmall?.copyWith(
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
