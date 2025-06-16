import 'package:eaqarati_app/core/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class PropertyListItemShimmer extends StatelessWidget {
  const PropertyListItemShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final _baseColor = colorScheme.onSurfaceVariant.withOpacity(0.1);
    final _highlightColor = colorScheme.onSurfaceVariant.withOpacity(0.2);
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
          Shimmer.fromColors(
            highlightColor: _highlightColor,
            baseColor: _baseColor,
            direction: ShimmerDirection.ltr,
            period: const Duration(seconds: 1),
            child: Container(
              width: 48,
              height: 48,
              color: colorScheme.onSurfaceVariant.withOpacity(0.1),
            ),
          ),
          const SizedBox(width: kVerticalSpaceMedium),
          Shimmer.fromColors(
            baseColor: _baseColor,
            highlightColor: _highlightColor,
            child: Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Shimmer.fromColors(
                    highlightColor: _highlightColor,
                    baseColor: _baseColor,
                    direction: ShimmerDirection.ltr,
                    period: const Duration(seconds: 1),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.4,
                      height: 16,
                      color: colorScheme.onSurfaceVariant.withOpacity(0.1),
                    ),
                  ),
                  const SizedBox(height: kVerticalSpaceSmall / 2),
                  Shimmer.fromColors(
                    highlightColor: _highlightColor,
                    baseColor: _baseColor,
                    direction: ShimmerDirection.ltr,
                    period: const Duration(seconds: 1),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.3,
                      height: 12,
                      color: colorScheme.onSurfaceVariant.withOpacity(0.1),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
