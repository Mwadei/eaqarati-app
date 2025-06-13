import 'package:eaqarati_app/core/utils/constants.dart';
import 'package:eaqarati_app/core/utils/enum.dart';
import 'package:flutter/material.dart';

class ReminderItemData {
  final ReminderType type;
  final String title;
  final String details;
  final IconData? customIcon;
  ReminderItemData({
    this.customIcon,
    required this.type,
    required this.title,
    required this.details,
  });
}

class ReminderCard extends StatelessWidget {
  final ReminderItemData reminder;
  const ReminderCard({required this.reminder});

  IconData _getReminderIcon(ReminderType type) {
    return reminder.customIcon ??
        (type == ReminderType.rent
            ? Icons.hourglass_top_rounded
            : Icons.event_repeat_outlined);
  }

  Color _getReminderIconColor(ReminderType type, ColorScheme cs) {
    switch (type) {
      case ReminderType.rent:
        return Colors.orange.shade800;
      case ReminderType.renewal:
        return cs.primary;
    }
  }

  Color _getReminderBgColor(
    ReminderType type,
    ColorScheme cs,
    BuildContext context,
  ) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    switch (type) {
      case ReminderType.rent:
        return isDark
            ? Colors.orange.shade900.withOpacity(0.4)
            : Colors.orange.shade200;
      case ReminderType.renewal:
        return isDark
            ? cs.primaryContainer.withOpacity(0.2)
            : cs.primaryContainer.withOpacity(0.3);
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      elevation: 0.0, // More flat design
      margin: const EdgeInsets.only(bottom: kVerticalSpaceSmall),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: _getReminderIconColor(
            reminder.type,
            colorScheme,
          ).withOpacity(0.3),
          width: 1,
        ),
      ),
      color: _getReminderBgColor(reminder.type, colorScheme, context),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: kPagePadding / 1.5,
          vertical: kVerticalSpaceMedium * 0.7,
        ),
        child: Row(
          children: [
            Icon(
              _getReminderIcon(reminder.type),
              color: _getReminderIconColor(reminder.type, colorScheme),
              size: 26,
            ),
            const SizedBox(width: kVerticalSpaceMedium * 0.75),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    reminder.title,
                    style: textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: _getReminderIconColor(reminder.type, colorScheme),
                    ),
                  ),
                  const SizedBox(height: kVerticalSpaceSmall / 3),
                  Text(
                    reminder.details,
                    style: textTheme.bodySmall?.copyWith(
                      color: _getReminderIconColor(
                        reminder.type,
                        colorScheme,
                      ).withOpacity(0.9),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 14,
              color: _getReminderIconColor(
                reminder.type,
                colorScheme,
              ).withOpacity(0.7),
            ),
          ],
        ),
      ),
    );
  }
}
