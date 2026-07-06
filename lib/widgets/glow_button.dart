import 'package:flutter/material.dart';

import '../theme/neon_carbon_colors.dart';
import '../theme/neon_carbon_theme.dart';

/// Nút có glow cyan (guideline §4.4).
/// [primary] = nền cyan chữ carbon; ngược lại = viền cyan trong suốt.
class GlowButton extends StatelessWidget {
  const GlowButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.primary = true,
    this.icon,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool primary;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final fg = primary ? context.nc.carbon : context.nc.cyan;
    final child = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null) ...[
          Icon(icon, size: 16, color: fg),
          const SizedBox(width: 8),
        ],
        Text(label.toUpperCase(), style: NcText.label(size: 11, color: fg)),
      ],
    );

    return DecoratedBox(
      decoration: BoxDecoration(
        boxShadow: onPressed == null
            ? null
            : [
                BoxShadow(
                  color: context.nc.cyanGlow,
                  blurRadius: 14,
                  spreadRadius: -3,
                ),
              ],
      ),
      child: primary
          ? FilledButton(
              onPressed: onPressed,
              style: FilledButton.styleFrom(
                backgroundColor: context.nc.cyan,
                foregroundColor: context.nc.carbon,
                shape: const RoundedRectangleBorder(),
              ),
              child: child,
            )
          : OutlinedButton(
              onPressed: onPressed,
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: context.nc.cyan),
                foregroundColor: context.nc.cyan,
                shape: const RoundedRectangleBorder(),
              ),
              child: child,
            ),
    );
  }
}
