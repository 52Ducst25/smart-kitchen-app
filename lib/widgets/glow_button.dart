import 'package:flutter/material.dart';

import '../theme/neon_carbon_colors.dart';
import '../theme/neon_carbon_theme.dart';

/// Nút kiểu Velzon Material. (Reskin từ "glow button" — đã bỏ glow, giữ tên/API.)
/// [primary]=true → nút đặc màu primary (tím), chữ trắng. Ngược lại → nút "soft":
/// nền primary pha loãng + chữ primary.
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
    final nc = context.nc;
    final fg = primary ? Colors.white : nc.cyan;
    final child = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null) ...[
          Icon(icon, size: 16, color: fg),
          const SizedBox(width: 8),
        ],
        Text(label, style: NcText.label(size: 12, color: fg)),
      ],
    );

    final shape = RoundedRectangleBorder(borderRadius: BorderRadius.circular(6));
    return FilledButton(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        backgroundColor: primary ? nc.cyan : nc.cyanDim, // đặc / soft
        foregroundColor: fg,
        elevation: 0,
        shape: shape,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      child: child,
    );
  }
}
