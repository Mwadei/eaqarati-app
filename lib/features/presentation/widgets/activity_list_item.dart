import 'package:eaqarati_app/core/utils/constants.dart';
import 'package:eaqarati_app/core/utils/enum.dart';
import 'package:flutter/material.dart';

class RecentActivityItemData {
  final ActivityType type;
  final String title;
  final String subtitle;
  final String time;
  RecentActivityItemData({
    required this.type,
    required this.title,
    required this.subtitle,
    required this.time,
  });
}

class ActivityListItem extends StatelessWidget {
  final RecentActivityItemData activity;
  const ActivityListItem({super.key, required this.activity});

  IconData _getActivityIcon(ActivityType type) {
    switch (type) {
      case ActivityType.payment:
        return Icons.check_circle_outline_rounded;
      case ActivityType.lease:
        return Icons.person_add_alt_1_outlined;
      case ActivityType.maintenance:
        return Icons.construction_outlined;
    }
  }

  Color _getActivityIconColor(ActivityType type, ColorScheme cs) {
    switch (type) {
      case ActivityType.payment:
        return cs.primary; // Using primary for success
      case ActivityType.lease:
        return Colors.blue.shade700;
      case ActivityType.maintenance:
        return Colors.amber.shade800;
    }
  }

  Color _getActivityIconBgColor(ActivityType type, ColorScheme cs) {
    switch (type) {
      case ActivityType.payment:
        return cs.primaryContainer.withOpacity(0.3);
      case ActivityType.lease:
        return Colors.blue.shade200;
      case ActivityType.maintenance:
        return Colors.amber.shade200;
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return ListTile(
      dense: true,
      visualDensity: VisualDensity.compact,
      leading: Container(
        padding: const EdgeInsets.all(kVerticalSpaceSmall * 0.85),
        decoration: BoxDecoration(
          color: _getActivityIconBgColor(activity.type, colorScheme),
          shape: BoxShape.circle,
        ),
        child: Icon(
          _getActivityIcon(activity.type),
          color: _getActivityIconColor(activity.type, colorScheme),
          size: 20,
        ),
      ),
      title: Text(
        activity.title,
        style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        '${activity.subtitle} • ${activity.time}',
        style: textTheme.bodySmall?.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Icon(
        Icons.arrow_forward_ios_rounded,
        size: 14,
        color: colorScheme.onSurfaceVariant,
      ),
      onTap: () {
        /* TODO: Handle activity item tap */
      },
    );
  }
}
