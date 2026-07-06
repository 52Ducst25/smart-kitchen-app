import 'package:flutter/material.dart';

import '../theme/neon_carbon_colors.dart';

/// Khung "tech-bracket" (guideline §4.1): viền hairline + ngoặc vuông ở 4 góc,
/// vẽ hoàn toàn bằng CustomPainter (không dùng ảnh). Bọc bất kỳ child nào.
class TechBracketBox extends StatelessWidget {
  const TechBracketBox({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.bracketColor = NcColors.cyan,
    this.bracketSize = 14,
    this.background = NcColors.carbon,
    this.borderColor = NcColors.carbonLine,
    this.glow = false,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color bracketColor;
  final double bracketSize;
  final Color background;
  final Color borderColor;
  final bool glow;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _BracketPainter(bracketColor, bracketSize, borderColor),
      child: Container(
        padding: padding,
        decoration: BoxDecoration(
          color: background,
          boxShadow: glow
              ? const [
                  BoxShadow(
                    color: NcColors.cyanGlow,
                    blurRadius: 18,
                    spreadRadius: -3,
                  ),
                ]
              : null,
        ),
        child: child,
      ),
    );
  }
}

class _BracketPainter extends CustomPainter {
  _BracketPainter(this.color, this.len, this.border);

  final Color color;
  final double len;
  final Color border;

  @override
  void paint(Canvas canvas, Size size) {
    final borderPaint = Paint()
      ..color = border
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    canvas.drawRect(Offset.zero & size, borderPaint);

    final p = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4;
    final w = size.width;
    final h = size.height;

    // top-left
    canvas.drawLine(Offset.zero, Offset(len, 0), p);
    canvas.drawLine(Offset.zero, Offset(0, len), p);
    // top-right
    canvas.drawLine(Offset(w, 0), Offset(w - len, 0), p);
    canvas.drawLine(Offset(w, 0), Offset(w, len), p);
    // bottom-left
    canvas.drawLine(Offset(0, h), Offset(len, h), p);
    canvas.drawLine(Offset(0, h), Offset(0, h - len), p);
    // bottom-right
    canvas.drawLine(Offset(w, h), Offset(w - len, h), p);
    canvas.drawLine(Offset(w, h), Offset(w, h - len), p);
  }

  @override
  bool shouldRepaint(_BracketPainter old) =>
      old.color != color || old.len != len || old.border != border;
}
