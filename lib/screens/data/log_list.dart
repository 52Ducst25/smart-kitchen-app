import 'package:flutter/material.dart';

import '../../models/log_entry.dart';
import '../../theme/neon_carbon_colors.dart';
import '../../theme/neon_carbon_theme.dart';

/// Danh sách nhật ký hoạt động (tối đa 8 dòng gần nhất), tô màu theo mức.
class LogList extends StatelessWidget {
  const LogList({super.key, required this.logs});

  final List<LogEntry> logs;

  @override
  Widget build(BuildContext context) {
    if (logs.isEmpty) {
      return Text('Chưa có nhật ký.', style: NcText.body());
    }
    return Column(
      children: [
        for (final e in logs)
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: NcColors.carbonLine)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  e.isDanger ? Icons.warning_amber_rounded : Icons.info_outline,
                  size: 14,
                  color: e.isDanger ? NcColors.red : NcColors.whiteDim,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    e.msg,
                    style: NcText.body(size: 12, color: NcColors.white),
                  ),
                ),
                const SizedBox(width: 8),
                Text(e.time, style: NcText.mono(size: 9, color: NcColors.whiteDim)),
              ],
            ),
          ),
      ],
    );
  }
}
