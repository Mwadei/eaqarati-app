import 'package:eaqarati_app/core/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class UnitItemShimmer extends StatelessWidget {
  const UnitItemShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final _baseColor = colorScheme.onSurfaceVariant.withOpacity(0.1);
    final _highlightColor = colorScheme.onSurfaceVariant.withOpacity(0.2);
    return Container(
      margin: const EdgeInsets.only(bottom: kVerticalSpaceMedium * 0.75),
      padding: const EdgeInsets.all(kPagePadding / 2),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Shimmer.fromColors(
            baseColor: _baseColor,
            highlightColor: _highlightColor,
            direction: ShimmerDirection.rtl,
            period: const Duration(seconds: 1),
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: colorScheme.surfaceVariant,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(width: kVerticalSpaceMedium * 0.75),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Shimmer.fromColors(
                  baseColor: _baseColor,
                  highlightColor: _highlightColor,
                  direction: ShimmerDirection.rtl,
                  period: const Duration(seconds: 1),
                  child: Container(
                    width: double.infinity,
                    height: 18,
                    color: colorScheme.surfaceVariant,
                  ),
                ),
                const SizedBox(height: kVerticalSpaceSmall / 2),
                Shimmer.fromColors(
                  baseColor: _baseColor,
                  highlightColor: _highlightColor,
                  direction: ShimmerDirection.rtl,
                  period: const Duration(seconds: 1),
                  child: Container(
                    width: 150,
                    height: 14,
                    color: colorScheme.surfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: kVerticalSpaceSmall),
          Shimmer.fromColors(
            baseColor: _baseColor,
            highlightColor: _highlightColor,
            direction: ShimmerDirection.rtl,
            period: const Duration(seconds: 1),
            child: Container(
              width: 80,
              height: 28,
              decoration: BoxDecoration(
                color: colorScheme.surfaceVariant,
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
