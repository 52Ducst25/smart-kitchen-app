import 'package:flutter/material.dart';

import '../theme/neon_carbon_colors.dart';
import '../theme/neon_carbon_theme.dart';
import 'pulse_dot.dart';

/// Header HUD dùng chung cho 3 tab: chấm trạng thái + tiêu đề + phụ đề + badge demo.
class HudHeader extends StatelessWidget {
  const HudHeader({
    super.key,
    required this.title,
    required this.subtitle,
    this.statusColor,
    this.demo = false,
  });

  final String title;
  final String subtitle;
  final Color? statusColor;
  final bool demo;

  @override
  Widget build(BuildContext context) {
    final statusColor = this.statusColor ?? context.nc.green;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            PulseDot(color: statusColor, size: 10),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                title.toUpperCase(),
                style: NcText.heading(size: 18, color: context.nc.white),
              ),
            ),
            if (demo)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: context.nc.amber.withValues(alpha: 0.15),
                  border: Border.all(color: context.nc.amber),
                ),
                child: Text('DEMO', style: NcText.label(size: 9, color: context.nc.amber)),
              ),
          ],
        ),
        const SizedBox(height: 4),
        Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Text(subtitle, style: NcText.mono(size: 10, color: context.nc.whiteDim)),
        ),
      ],
    );
  }
}
