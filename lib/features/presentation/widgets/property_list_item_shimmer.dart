import 'package:eaqarati_app/core/utils/constants.dart';
import 'package:flutter/material.dart';

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
