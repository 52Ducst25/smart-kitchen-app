import 'package:flutter/material.dart';

import '../theme/neon_carbon_colors.dart';

/// Card phẳng kiểu Velzon Material: nền panel, bo góc nhẹ, viền 1px, bóng đổ mềm.
/// (Trước đây là khung "tech-bracket" HUD — đã reskin sang card phẳng; giữ tên
/// & API để không phải sửa nơi gọi.)
///
/// [bracketColor] set khi thẻ ở trạng thái nhấn (alert/đang chọn) → dùng làm màu
/// VIỀN nhấn; [glow]=true kèm màu đó → thêm quầng bóng mềm.
class TechBracketBox extends StatelessWidget {
  const TechBracketBox({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.bracketColor,
    this.bracketSize = 14, // giữ cho tương thích API (không còn dùng)
    this.background,
    this.borderColor,
    this.glow = false,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color? bracketColor;
  final double bracketSize;
  final Color? background;
  final Color? borderColor;
  final bool glow;

  @override
  Widget build(BuildContext context) {
    final nc = context.nc;
    final accent = bracketColor; // != null khi alert / đang chọn
    final border = accent ?? borderColor ?? nc.carbonLine;
    final bg = background ?? nc.carbonPanel;
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: border, width: accent != null ? 1.4 : 1),
        boxShadow: (glow && accent != null)
            ? [
                BoxShadow(
                  color: accent.withValues(alpha: 0.22),
                  blurRadius: 14,
                  spreadRadius: -4,
                ),
              ]
            : const [
                BoxShadow(
                  color: Color(0x1A000000),
                  blurRadius: 6,
                  offset: Offset(0, 2),
                ),
              ],
      ),
      child: child,
    );
  }
}
