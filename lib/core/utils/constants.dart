import 'package:eaqarati_app/core/utils/enum.dart';
import 'package:flutter/material.dart';

// spacing
const double kVerticalSpaceSmall = 8.0;
const double kVerticalSpaceMedium = 16.0;
const double kPagePadding = 24.0;

//colors
const Color kStarColor = Color(0xFFFFC107);
const Color kSecondaryTextColor = Color(0xFF757575);

IconData getPropertyTypeIcon(PropertyType type) {
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

Color getPropertyIconBackgroundColor(
  PropertyType type,
  ColorScheme colorScheme,
) {
  if (type == PropertyType.apartment || type == PropertyType.building) {
    return Colors.blue.withOpacity(0.1);
  } else if (type == PropertyType.chalet || type == PropertyType.villa) {
    return Colors.green.withOpacity(0.1);
  } else if (type == PropertyType.office) {
    return Colors.orange.withOpacity(0.1);
  } else if (type == PropertyType.residentialComplex) {
    return Colors.purple.withOpacity(0.1);
  }
  return colorScheme.primaryContainer.withOpacity(0.1);
}

Color getPropertyIconColor(PropertyType type, ColorScheme colorScheme) {
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
