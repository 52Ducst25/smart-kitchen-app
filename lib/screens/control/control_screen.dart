import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../state/app_state.dart';
import '../../theme/neon_carbon_colors.dart';
import '../../theme/neon_carbon_theme.dart';
import '../../widgets/hud_header.dart';
import '../../widgets/section_label.dart';
import 'device_row.dart';
import 'mode_switcher.dart';

/// Tab Control — chọn chế độ & bật/tắt 4 thiết bị chấp hành.
class ControlScreen extends StatelessWidget {
  const ControlScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = context.watch<AppState>();
    final c = s.controls;
    final manual = c.isManual;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        HudHeader(
          title: 'Điều khiển',
          subtitle: manual
              ? 'THỦ CÔNG • BẠN ĐANG ĐIỀU KHIỂN'
              : 'TỰ ĐỘNG • FIRMWARE ĐIỀU KHIỂN',
          statusColor: s.isDanger ? NcColors.red : NcColors.green,
          demo: s.isDemo,
        ),
        const SizedBox(height: 16),
        const SectionLabel('Chế độ'),
        const SizedBox(height: 10),
        ModeSwitcher(mode: c.mode, onChanged: (m) => s.setMode(m)),
        const SizedBox(height: 20),
        const SectionLabel('Thiết bị chấp hành'),
        const SizedBox(height: 10),
        if (!manual)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(
              'Chuyển sang THỦ CÔNG để điều khiển tay. Ở chế độ Tự động, firmware '
              'tự đóng van / bật quạt / bơm theo ngưỡng.',
              style: NcText.body(size: 12, color: NcColors.amber),
            ),
          ),
        DeviceRow(
          icon: Icons.local_fire_department_outlined,
          name: 'Van gas (Servo)',
          on: c.valve,
          onDesc: 'Đang mở',
          offDesc: 'Đã đóng',
          enabled: manual,
          onChanged: (v) => _toggleValve(context, s, v),
        ),
        DeviceRow(
          icon: Icons.air,
          name: 'Quạt hút khí',
          on: c.exhaustFan,
          onDesc: 'Đang chạy',
          offDesc: 'Tắt',
          enabled: manual,
          onChanged: (v) => s.setDevice('exhaustFan', v),
        ),
        DeviceRow(
          icon: Icons.ac_unit,
          name: 'Quạt làm mát',
          on: c.coolFan,
          onDesc: 'Đang chạy',
          offDesc: 'Tắt',
          enabled: manual,
          onChanged: (v) => s.setDevice('coolFan', v),
        ),
        DeviceRow(
          icon: Icons.water_drop_outlined,
          name: 'Bơm nước chữa cháy',
          on: c.pump,
          onDesc: 'Đang bơm',
          offDesc: 'Tắt',
          enabled: manual,
          onChanged: (v) => s.setDevice('pump', v),
        ),
      ],
    );
  }

  /// Mở van gas khi đang nguy hiểm cần xác nhận (an toàn vật lý).
  Future<void> _toggleValve(BuildContext context, AppState s, bool v) async {
    if (v && s.isDanger) {
      final ok = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          backgroundColor: NcColors.carbonPanel,
          title: Text('Mở van gas?', style: NcText.heading(size: 16)),
          content: Text(
            'Hệ thống đang cảnh báo nguy hiểm. Mở van gas lúc này có thể không '
            'an toàn. Tiếp tục?',
            style: NcText.body(size: 13),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Huỷ'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Mở', style: TextStyle(color: NcColors.red)),
            ),
          ],
        ),
      );
      if (ok != true) return;
    }
    await s.setDevice('valve', v);
  }
}
