import 'package:eaqarati_app/core/utils/constants.dart';
import 'package:eaqarati_app/core/utils/enum.dart';
import 'package:eaqarati_app/features/domain/entities/units_entity.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class UnitListItem extends StatelessWidget {
  final PropertyType propertyType;
  final UnitsEntity unit;
  final Animation<double> animation;

  const UnitListItem({
    super.key,
    required this.propertyType,
    required this.unit,
    required this.animation,
  });

  String getShortUnitIdentifier(String unitNumber) {
    if (unitNumber.length <= 2) return unitNumber.toUpperCase();
    final match = RegExp(r'^([A-Za-z]+)(\d+)').firstMatch(unitNumber);
    if (match != null && match.groupCount == 2) {
      return (match.group(1)![0] + match.group(2)![0]).toUpperCase();
    }
    return unitNumber.substring(0, 1).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    Color statusColor;
    Color statusTextColor;
    String statusText;

    switch (unit.status) {
      case UnitStatus.vacant:
        statusColor = const Color(0xFFDCFCE7);
        statusTextColor = const Color(0xFF16A34A);
        statusText = 'units.status_vacant'.tr();
        break;
      case UnitStatus.occupied:
        statusColor = const Color(0xFFFEF9C3);
        statusTextColor = const Color(0xFFB45309);
        statusText = 'units.status_occupied'.tr();
        break;
      case UnitStatus.underMaintenance:
        statusColor = Colors.grey.shade200;
        statusTextColor = Colors.grey.shade700;
        statusText = 'units.status_maintenance'.tr();
        break;
    }

    return FadeTransition(
      opacity: animation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.2),
          end: Offset.zero,
        ).animate(
          CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
        ),
        child: InkWell(
          onTap: () async {
            if (unit.unitId != null) {
              await context.pushNamed(
                'unitDetails',
                pathParameters: {
                  'unitId': unit.unitId.toString(),
                  'propertyType': propertyType.toString(),
                },
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Error: Unit ID is missing.')),
              );
            }
          },
          child: Card(
            elevation: 0.5,
            margin: const EdgeInsets.only(bottom: kVerticalSpaceMedium * 0.75),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            color: colorScheme.surface,
            child: Padding(
              padding: const EdgeInsets.all(kPagePadding / 2),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: const Color(0xFFEDE9FE),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        getShortUnitIdentifier(unit.unitNumber),
                        style: textTheme.titleSmall?.copyWith(
                          color: const Color(0xFF8B5CF6),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: kVerticalSpaceMedium * 0.75),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'units.unit_prefix'.tr(args: [unit.unitNumber]),
                          style: textTheme.titleSmall?.copyWith(
                            color: colorScheme.onSurface,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (unit.description != null &&
                            unit.description!.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 2.0),
                            child: Text(
                              unit.description!,
                              style: textTheme.bodySmall?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(width: kVerticalSpaceSmall),
                  Chip(
                    label: Text(statusText),
                    backgroundColor: statusColor,
                    labelStyle: textTheme.labelSmall?.copyWith(
                      color: statusTextColor,
                      fontWeight: FontWeight.w600,
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
