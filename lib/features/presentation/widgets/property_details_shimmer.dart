import 'package:eaqarati_app/core/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class PropertyDetailsShimmer extends StatelessWidget {
  const PropertyDetailsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final _baseColor = colorScheme.onSurfaceVariant.withOpacity(0.1);
    final _highlightColor = colorScheme.onSurfaceVariant.withOpacity(0.2);
    Widget shimmerContainer({
      double? width,
      double height = 16,
      double radius = 8,
    }) {
      return Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white, // Shimmer needs a non-transparent color
          borderRadius: BorderRadius.circular(radius),
        ),
      );
    }

    return Shimmer.fromColors(
      baseColor: _baseColor,
      highlightColor: _highlightColor,
      period: const Duration(seconds: 1),
      direction: ShimmerDirection.rtl,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(kPagePadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Property Info Card Shimmer
            Container(
              padding: const EdgeInsets.all(kPagePadding / 1.5),
              decoration: BoxDecoration(
                color: Colors.white, // For shimmer
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            shimmerContainer(width: 200, height: 24),
                            const SizedBox(height: kVerticalSpaceSmall / 2),
                            shimmerContainer(width: 100, height: 18),
                          ],
                        ),
                      ),
                      const SizedBox(width: kVerticalSpaceMedium),
                      shimmerContainer(width: 56, height: 56, radius: 12),
                    ],
                  ),
                  const SizedBox(height: kVerticalSpaceMedium * 1.5),
                  for (int i = 0; i < 3; i++) ...[
                    Row(
                      children: [
                        shimmerContainer(width: 24, height: 24, radius: 24),
                        const SizedBox(width: kVerticalSpaceSmall),
                        Expanded(child: shimmerContainer(height: 16)),
                      ],
                    ),
                    if (i < 2)
                      const SizedBox(height: kVerticalSpaceSmall * 1.25),
                  ],
                ],
              ),
            ),
            const SizedBox(height: kVerticalSpaceMedium * 1.5),

            // Units Header Shimmer
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                shimmerContainer(width: 80, height: 22),
                shimmerContainer(width: 100, height: 30, radius: 15),
              ],
            ),
            const SizedBox(height: kVerticalSpaceMedium),

            // Unit List Shimmer
            for (int i = 0; i < 3; i++) ...[
              Container(
                margin: const EdgeInsets.only(
                  bottom: kVerticalSpaceMedium * 0.75,
                ),
                padding: const EdgeInsets.all(kPagePadding / 2),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    shimmerContainer(width: 48, height: 48, radius: 10),
                    const SizedBox(width: kVerticalSpaceMedium * 0.75),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          shimmerContainer(width: double.infinity, height: 18),
                          const SizedBox(height: kVerticalSpaceSmall / 2),
                          shimmerContainer(width: 150, height: 14),
                        ],
                      ),
                    ),
                    const SizedBox(width: kVerticalSpaceSmall),
                    shimmerContainer(width: 80, height: 28, radius: 14),
                  ],
                ),
              ),
            ],
            const SizedBox(height: kVerticalSpaceMedium * 2),
            // Action Buttons Shimmer
            Row(
              children: [
                Expanded(child: shimmerContainer(height: 50, radius: 12)),
                const SizedBox(width: kVerticalSpaceSmall),
                Expanded(child: shimmerContainer(height: 50, radius: 12)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
