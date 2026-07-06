import 'package:flutter/material.dart';

import '../../theme/neon_carbon_colors.dart';
import '../../theme/neon_carbon_theme.dart';
import '../../widgets/pulse_dot.dart';

/// Banner cảnh báo đỏ khi hệ thống ở trạng thái nguy hiểm; liệt kê lý do.
class DangerBanner extends StatelessWidget {
  const DangerBanner({super.key, required this.alerts});

  final List<String> alerts;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: NcColors.red.withValues(alpha: 0.12),
        border: Border.all(color: NcColors.red),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const PulseDot(color: NcColors.red, size: 10),
              const SizedBox(width: 10),
              Text('NGUY HIỂM', style: NcText.label(size: 12, color: NcColors.red)),
            ],
          ),
          const SizedBox(height: 8),
          for (final a in alerts)
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Text('• $a', style: NcText.body(size: 12, color: NcColors.white)),
            ),
        ],
      ),
    );
  }
}
