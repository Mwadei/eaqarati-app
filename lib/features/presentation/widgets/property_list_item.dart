import 'package:eaqarati_app/core/utils/constants.dart';
import 'package:eaqarati_app/core/utils/enum.dart';
import 'package:eaqarati_app/features/domain/entities/property_entity.dart';
import 'package:eaqarati_app/features/presentation/blocs/units/units_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';

class PropertyListItem extends HookWidget {
  final PropertyEntity property;

  const PropertyListItem({super.key, required this.property});

  IconData _getPropertyTypeIcon(PropertyType type) {
    if (type == PropertyType.apartment || type == PropertyType.building) {
      return Icons.apartment_rounded;
    } else if (type == PropertyType.chalet || type == PropertyType.villa) {
      return Icons.villa_rounded;
    } else if (type == PropertyType.office) {
      return Icons.workspaces_outline;
    } else if (type == PropertyType.residentialComplex) {
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
    } else if (type == PropertyType.residentialComplex) {
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
    } else if (type == PropertyType.residentialComplex) {
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
          if (property.propertyId != null) {
            context.pushNamed(
              'propertyDetails',
              pathParameters: {'propertyId': '${property.propertyId}'},
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Error: Property ID is missing.')),
            );
          }
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
                        color: colorScheme.onPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: kVerticalSpaceSmall / 3),
                    Text(
                      'add_edit_property_screen.propertyType_${property.type.name}'
                          .tr(), // Or a localized version of type
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
                                namedArgs: {'count': unitCount.toString()},
                                // args: [unitCount.toString()],
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
