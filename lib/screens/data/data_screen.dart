import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/sensor_metric.dart';
import '../../state/app_state.dart';
import '../../theme/neon_carbon_colors.dart';
import '../../theme/neon_carbon_theme.dart';
import '../../widgets/hud_header.dart';
import '../../widgets/section_label.dart';
import 'danger_banner.dart';
import 'log_list.dart';
import 'sensor_grid.dart';
import 'sensor_history_chart.dart';

/// Tab Data — dashboard giám sát cảm biến, cảnh báo, biểu đồ, nhật ký.
/// Chạm 1 thẻ cảm biến → hiện biểu đồ giá trị đo thật của chỉ số đó.
class DataScreen extends StatefulWidget {
  const DataScreen({super.key});

  @override
  State<DataScreen> createState() => _DataScreenState();
}

class _DataScreenState extends State<DataScreen> {
  SensorMetric? _selected; // null = chưa chọn → chưa hiện biểu đồ

  @override
  Widget build(BuildContext context) {
    final s = context.watch<AppState>();
    final modeLabel = s.controls.mode.name.toUpperCase();
    final selected = _selected;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        HudHeader(
          title: 'N&Đ',
          subtitle: (s.isDemo || s.demoMode)
              ? 'DỮ LIỆU MẪU • $modeLabel'
              : 'TRỰC TUYẾN • $modeLabel',
          statusColor: s.isDanger ? context.nc.red : context.nc.green,
          demo: s.isDemo || s.demoMode,
        ),
        const SizedBox(height: 16),
        if (s.isDanger) ...[
          DangerBanner(alerts: s.activeAlerts),
          const SizedBox(height: 16),
        ],
        Row(
          children: [
            const Expanded(
              child: SectionLabel('Cảm biến • chạm để xem biểu đồ'),
            ),
            Text('MẪU', style: NcText.label(size: 9, color: context.nc.cyanText)),
            Switch(
              value: s.demoMode,
              onChanged: (v) => context.read<AppState>().toggleDemo(v),
            ),
          ],
        ),
        const SizedBox(height: 10),
        SensorGrid(
          data: s.sensors,
          settings: s.settings,
          selected: selected,
          // Chạm lại thẻ đang chọn → bỏ chọn (ẩn biểu đồ).
          onSelect: (m) =>
              setState(() => _selected = _selected == m ? null : m),
        ),
        const SizedBox(height: 20),
        if (selected != null) ...[
          Row(
            children: [
              Expanded(child: SectionLabel('Biểu đồ • ${selected.label}')),
              TextButton(
                onPressed: () => setState(() => _selected = null),
                child: Text(
                  'ĐÓNG',
                  style: NcText.label(size: 11, color: context.nc.whiteDim),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          MetricHistoryChart(
            history: s.history,
            metric: selected,
            color: metricAccent(context.nc, selected),
          ),
          const SizedBox(height: 20),
        ] else ...[
          Container(
            padding: const EdgeInsets.symmetric(vertical: 26),
            alignment: Alignment.center,
            child: Text(
              'Chạm vào một cảm biến để xem biểu đồ giá trị đo',
              style: NcText.body(size: 12, color: context.nc.whiteDim),
            ),
          ),
          const SizedBox(height: 20),
        ],
        const SectionLabel('Nhật ký hoạt động'),
        const SizedBox(height: 10),
        LogList(logs: s.logs),
      ],
    );
  }
}
