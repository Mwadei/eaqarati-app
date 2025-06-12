import 'package:eaqarati_app/core/utils/constants.dart';
import 'package:flutter/material.dart';

class CardLoadingShimmer extends StatelessWidget {
  const CardLoadingShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(kPagePadding / 1.5),
      decoration: BoxDecoration(
        color: colorScheme.surfaceVariant.withOpacity(0.3),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 30,
            height: 30,
            color: colorScheme.onSurfaceVariant.withOpacity(0.1),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 80,
                height: 20,
                color: colorScheme.onSurfaceVariant.withOpacity(0.1),
              ),
              const SizedBox(height: kVerticalSpaceSmall / 2),
              Container(
                width: 100,
                height: 14,
                color: colorScheme.onSurfaceVariant.withOpacity(0.1),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
