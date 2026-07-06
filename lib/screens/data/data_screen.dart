import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../state/app_state.dart';
import '../../theme/neon_carbon_colors.dart';
import '../../theme/neon_carbon_theme.dart';
import '../../widgets/hud_header.dart';
import '../../widgets/section_label.dart';
import 'danger_banner.dart';
import 'log_list.dart';
import 'sensor_grid.dart';
import 'sensor_history_chart.dart';

/// Tab Data — dashboard giám sát cảm biến, cảnh báo, lịch sử, nhật ký.
class DataScreen extends StatelessWidget {
  const DataScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = context.watch<AppState>();
    final modeLabel = s.controls.mode.name.toUpperCase();
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        HudHeader(
          title: 'N&Đ',
          subtitle: (s.isDemo || s.demoMode)
              ? 'DỮ LIỆU MẪU • $modeLabel'
              : 'TRỰC TUYẾN • $modeLabel',
          statusColor: s.isDanger ? NcColors.red : NcColors.green,
          demo: s.isDemo || s.demoMode,
        ),
        const SizedBox(height: 16),
        if (s.isDanger) ...[
          DangerBanner(alerts: s.activeAlerts),
          const SizedBox(height: 16),
        ],
        const SectionLabel('Cảm biến'),
        const SizedBox(height: 10),
        SensorGrid(data: s.sensors, settings: s.settings),
        const SizedBox(height: 20),
        Row(
          children: [
            const Expanded(
              child: SectionLabel('Biểu đồ • Connected scatterplot'),
            ),
            Text('MẪU TỰ ĐỘNG', style: NcText.label(size: 9, color: NcColors.cyanText)),
            Switch(
              value: s.demoMode,
              onChanged: (v) => context.read<AppState>().toggleDemo(v),
            ),
          ],
        ),
        const SizedBox(height: 10),
        SensorHistoryChart(history: s.history),
        const SizedBox(height: 20),
        const SectionLabel('Nhật ký hoạt động'),
        const SizedBox(height: 10),
        LogList(logs: s.logs),
      ],
    );
  }
}
