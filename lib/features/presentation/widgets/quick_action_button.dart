import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class QuickActionButton extends HookWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const QuickActionButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final isPressed = useState(false);
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: onTap,
          onTapDown: (_) => isPressed.value = true,
          onTapUp: (_) => isPressed.value = false,
          onTapCancel: () => isPressed.value = false,
          child: AnimatedScale(
            scale: isPressed.value ? 0.9 : 1.0,
            duration: const Duration(milliseconds: 100),
            curve: Curves.easeOut,
            child: Container(
              width: 60,
              height: 80,
              decoration: BoxDecoration(
                color: theme.colorScheme.shadow,
                shape: BoxShape.circle,
                border: Border.all(
                  color: theme.iconTheme.color ?? Color(0xFF607D8B),
                  width: 2,
                ),
              ),
              child: Align(
                alignment: AlignmentDirectional(0, 0),
                child: Icon(icon, color: theme.iconTheme.color, size: 28),
              ),
            ),
          ),
        ),
        Text(label, style: textTheme.bodyMedium?.copyWith(fontSize: 14)),
      ],
    );
  }
}
