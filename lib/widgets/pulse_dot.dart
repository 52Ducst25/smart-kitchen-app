import 'package:flutter/material.dart';

import '../theme/neon_carbon_colors.dart';

/// Chấm trạng thái phát nhịp bằng glow (guideline §4.7).
/// Tôn trọng reduce-motion: đứng yên khi người dùng tắt animation.
class PulseDot extends StatefulWidget {
  const PulseDot({super.key, this.color, this.size = 9});

  final Color? color;
  final double size;

  @override
  State<PulseDot> createState() => _PulseDotState();
}

class _PulseDotState extends State<PulseDot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1600),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.color ?? context.nc.green;
    final reduce = MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    if (reduce) return _dot(color, 1);
    return AnimatedBuilder(
      animation: _c,
      builder: (_, _) => _dot(color, 0.4 + _c.value * 0.6),
    );
  }

  Widget _dot(Color color, double intensity) {
    return Container(
      width: widget.size,
      height: widget.size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: intensity * 0.8),
            blurRadius: 8 * intensity,
            spreadRadius: 1,
          ),
        ],
      ),
    );
  }
}
