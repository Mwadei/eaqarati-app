import 'package:eaqarati_app/core/utils/constants.dart';
import 'package:flutter/material.dart';

class SummaryCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBgColor;
  final String count;
  final String label;
  final AnimationController animationController;
  final int itemIndex;
  final Widget? loadingWidget;
  const SummaryCard({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.iconBgColor,
    required this.count,
    required this.label,
    required this.animationController,
    required this.itemIndex,
    this.loadingWidget,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    final cardAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Interval(
          (0.05 * itemIndex).clamp(0.0, 1.0),
          (0.05 * itemIndex + 0.5).clamp(0.0, 1.0), // Staggered end
          curve: Curves.easeOutCubic,
        ),
      ),
    );
    return AnimatedBuilder(
      animation: cardAnimation,
      builder: (context, child) {
        return Opacity(
          opacity: cardAnimation.value,
          child: Transform.scale(
            scale: 0.95 + (cardAnimation.value * 0.05),
            child: Transform.translate(
              offset: Offset(0.0, 40 * (1.0 - cardAnimation.value)),
              child: child,
            ),
          ),
        );
      },
      child: Card(
        elevation: 0.2,
        shadowColor: colorScheme.shadow,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: colorScheme.surface,
        child:
            loadingWidget ??
            Padding(
              padding: const EdgeInsets.all(kPagePadding / 1.75),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.all(kVerticalSpaceSmall * 0.7),
                    decoration: BoxDecoration(
                      color: iconBgColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(icon, color: iconColor, size: 20),
                  ),
                  const Spacer(),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        count,
                        style: textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                        ),
                      ),
                      const SizedBox(height: kVerticalSpaceSmall),
                      Text(
                        label,
                        style: textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                        maxLines: 2, // Allow two lines for label if needed
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ],
              ),
            ),
      ),
    );
  }
}
