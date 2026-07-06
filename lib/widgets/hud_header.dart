import 'package:flutter/material.dart';

import '../theme/neon_carbon_colors.dart';
import '../theme/neon_carbon_theme.dart';
import 'pulse_dot.dart';

/// Header trang (Velzon): chấm trạng thái + tiêu đề + phụ đề muted + badge demo soft.
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
    final nc = context.nc;
    final statusColor = this.statusColor ?? nc.green;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            PulseDot(color: statusColor, size: 9),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                title,
                style: NcText.heading(size: 18, color: nc.white),
              ),
            ),
            if (demo)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: nc.amber.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Text(
                  'Demo',
                  style: NcText.label(size: 10, color: nc.amber),
                ),
              ),
          ],
        ),
        const SizedBox(height: 4),
        Padding(
          padding: const EdgeInsets.only(left: 19),
          child: Text(
            subtitle,
            style: NcText.body(size: 12, color: nc.whiteDim),
          ),
        ),
      ],
    );
  }
}
