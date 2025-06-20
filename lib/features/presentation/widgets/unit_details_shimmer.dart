import 'package:eaqarati_app/core/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class UnitDetailsShimmer extends StatelessWidget {
  const UnitDetailsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final baseColor = colorScheme.surfaceVariant.withOpacity(0.3);
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

    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(kPagePadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Unit Info Card Shimmer
            Container(
              padding: const EdgeInsets.all(kPagePadding / 1.5),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      shimmerContainer(width: 150, height: 26),
                      shimmerContainer(width: 48, height: 48, radius: 12),
                    ],
                  ),
                  const SizedBox(height: kVerticalSpaceSmall / 2),
                  shimmerContainer(
                    width: 100,
                    height: 20,
                    radius: 10,
                  ), // Status chip
                  const SizedBox(height: kVerticalSpaceMedium),
                  shimmerContainer(height: 14),
                  const SizedBox(height: kVerticalSpaceSmall / 2),
                  shimmerContainer(height: 14, width: 250),
                  const SizedBox(height: kVerticalSpaceSmall / 2),
                  shimmerContainer(height: 14, width: 200),
                  const SizedBox(height: kVerticalSpaceMedium * 1.5),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            shimmerContainer(width: 80, height: 12),
                            const SizedBox(height: kVerticalSpaceSmall / 2),
                            shimmerContainer(width: 100, height: 20),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            shimmerContainer(width: 60, height: 12),
                            const SizedBox(height: kVerticalSpaceSmall / 2),
                            shimmerContainer(width: 80, height: 20),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: kVerticalSpaceMedium * 1.5),

            // Lease Card Shimmer (optional structure)
            Container(
              padding: const EdgeInsets.all(kPagePadding / 1.5),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      shimmerContainer(width: 36, height: 36, isCircle: true),
                      const SizedBox(width: kVerticalSpaceSmall),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          shimmerContainer(width: 120, height: 18),
                          const SizedBox(height: kVerticalSpaceSmall / 2),
                          shimmerContainer(width: 150, height: 12),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: kVerticalSpaceMedium),
                  Container(
                    // Inner lease details
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
                                  shimmerContainer(width: 80, height: 12),
                                  const SizedBox(
                                    height: kVerticalSpaceSmall / 2,
                                  ),
                                  shimmerContainer(width: 100, height: 16),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  shimmerContainer(width: 70, height: 12),
                                  const SizedBox(
                                    height: kVerticalSpaceSmall / 2,
                                  ),
                                  shimmerContainer(width: 90, height: 16),
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
                                  shimmerContainer(width: 70, height: 12),
                                  const SizedBox(
                                    height: kVerticalSpaceSmall / 2,
                                  ),
                                  shimmerContainer(width: 90, height: 16),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  shimmerContainer(width: 60, height: 12),
                                  const SizedBox(
                                    height: kVerticalSpaceSmall / 2,
                                  ),
                                  shimmerContainer(width: 90, height: 16),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: kVerticalSpaceMedium),
                  shimmerContainer(height: 48, radius: 12), // Button
                ],
              ),
            ),
            const SizedBox(height: kVerticalSpaceMedium * 2),
            // Action Buttons Shimmer
            Row(
              children: [
                Expanded(child: shimmerContainer(height: 50, radius: 12)),
                const SizedBox(width: kVerticalSpaceSmall * 1.5),
                Expanded(child: shimmerContainer(height: 50, radius: 12)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
