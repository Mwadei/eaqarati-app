import 'package:eaqarati_app/core/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class LeaseCardShimmer extends StatelessWidget {
  const LeaseCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final baseColor = colorScheme.surfaceVariant.withOpacity(0.1);
    final highlightColor = colorScheme.surfaceVariant.withOpacity(0.5);

    Widget shimmerContainer({
      double? width,
      double height = 16,
      double radius = 8,
      bool isCircle = false,
    }) {
      return Container(
        width: width ?? double.infinity,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: isCircle ? null : BorderRadius.circular(radius),
          shape: isCircle ? BoxShape.circle : BoxShape.rectangle,
        ),
      );
    }

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
              children: [
                Shimmer.fromColors(
                  baseColor: baseColor,
                  highlightColor: highlightColor,
                  period: const Duration(seconds: 1),
                  direction: ShimmerDirection.rtl,
                  child: shimmerContainer(
                    width: 36,
                    height: 36,
                    isCircle: true,
                  ),
                ),
                const SizedBox(width: kVerticalSpaceSmall),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Shimmer.fromColors(
                      baseColor: baseColor,
                      highlightColor: highlightColor,
                      period: const Duration(seconds: 1),
                      direction: ShimmerDirection.rtl,
                      child: shimmerContainer(width: 120, height: 18),
                    ),
                    const SizedBox(height: kVerticalSpaceSmall / 2),
                    Shimmer.fromColors(
                      baseColor: baseColor,
                      highlightColor: highlightColor,
                      period: const Duration(seconds: 1),
                      direction: ShimmerDirection.rtl,
                      child: shimmerContainer(width: 150, height: 12),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: kVerticalSpaceMedium),
            Container(
              padding: const EdgeInsets.all(kPagePadding / 2),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: baseColor),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Shimmer.fromColors(
                              baseColor: baseColor,
                              highlightColor: highlightColor,
                              period: const Duration(seconds: 1),
                              direction: ShimmerDirection.rtl,
                              child: shimmerContainer(width: 80, height: 12),
                            ),
                            const SizedBox(height: kVerticalSpaceSmall / 2),
                            Shimmer.fromColors(
                              baseColor: baseColor,
                              highlightColor: highlightColor,
                              period: const Duration(seconds: 1),
                              direction: ShimmerDirection.rtl,
                              child: shimmerContainer(width: 100, height: 16),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Shimmer.fromColors(
                              baseColor: baseColor,
                              highlightColor: highlightColor,
                              period: const Duration(seconds: 1),
                              direction: ShimmerDirection.rtl,
                              child: shimmerContainer(width: 70, height: 12),
                            ),
                            const SizedBox(height: kVerticalSpaceSmall / 2),
                            Shimmer.fromColors(
                              baseColor: baseColor,
                              highlightColor: highlightColor,
                              period: const Duration(seconds: 1),
                              direction: ShimmerDirection.rtl,
                              child: shimmerContainer(width: 90, height: 16),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: kVerticalSpaceSmall),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Shimmer.fromColors(
                              baseColor: baseColor,
                              highlightColor: highlightColor,
                              period: const Duration(seconds: 1),
                              direction: ShimmerDirection.rtl,
                              child: shimmerContainer(width: 70, height: 12),
                            ),
                            const SizedBox(height: kVerticalSpaceSmall / 2),
                            Shimmer.fromColors(
                              baseColor: baseColor,
                              highlightColor: highlightColor,
                              period: const Duration(seconds: 1),
                              direction: ShimmerDirection.rtl,
                              child: shimmerContainer(width: 90, height: 16),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Shimmer.fromColors(
                              baseColor: baseColor,
                              highlightColor: highlightColor,
                              period: const Duration(seconds: 1),
                              direction: ShimmerDirection.rtl,
                              child: shimmerContainer(width: 60, height: 12),
                            ),
                            const SizedBox(height: kVerticalSpaceSmall / 2),
                            Shimmer.fromColors(
                              baseColor: baseColor,
                              highlightColor: highlightColor,
                              period: const Duration(seconds: 1),
                              direction: ShimmerDirection.rtl,
                              child: shimmerContainer(width: 90, height: 16),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: kVerticalSpaceMedium),
            Shimmer.fromColors(
              baseColor: baseColor,
              highlightColor: highlightColor,
              period: const Duration(seconds: 1),
              direction: ShimmerDirection.rtl,
              child: shimmerContainer(height: 48, radius: 12),
            ), // Button
          ],
        ),
      ),
    );
  }
}
