import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/controls.dart';
import '../state/app_state.dart';
import '../theme/neon_carbon_colors.dart';
import '../theme/neon_carbon_theme.dart';
import 'glow_button.dart';

/// Popup CẢNH BÁO NGUY HIỂM — tự hiện khi có sự cố (cháy/gas/khói/nhiệt vượt
/// ngưỡng), **KHÔNG cho tắt tay** (chặn back & chạm ngoài). Chỉ tự đóng khi đã
/// hết nguy hiểm (`isDanger=false`). Người dùng bấm nút xử lý (đóng van / bật
/// quạt / bơm) để đưa hệ về an toàn → popup mới mất.
class DangerAlertDialog extends StatelessWidget {
  const DangerAlertDialog({super.key});

  static Future<void> show(BuildContext context) => showDialog<void>(
        context: context,
        barrierDismissible: false, // không đóng khi chạm ra ngoài
        builder: (_) => const DangerAlertDialog(),
      );

  @override
  Widget build(BuildContext context) {
    final s = context.watch<AppState>();
    final nc = context.nc;

    // Hết nguy hiểm → tự đóng (sau frame, tránh pop giữa lúc build).
    if (!s.isDanger) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final nav = Navigator.of(context);
        if (nav.canPop()) nav.pop();
      });
    }

    final manual = s.controls.isManual;
    return PopScope(
      canPop: false, // chặn nút back — chỉ đóng khi hết nguy hiểm
      child: AlertDialog(
        backgroundColor: nc.carbonPanel,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: nc.red, width: 1.5),
        ),
        title: Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: nc.red, size: 26),
            const SizedBox(width: 8),
            Text('NGUY HIỂM', style: NcText.heading(size: 18, color: nc.red)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (final a in s.activeAlerts)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 3),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: Icon(Icons.circle, size: 6, color: nc.red),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(a, style: NcText.body(size: 13, color: nc.white)),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 14),
            if (manual) ...[
              Text('XỬ LÝ NGAY', style: NcText.label(size: 10, color: nc.whiteDim)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _act('Đóng van gas', Icons.block,
                      () => s.setDevice('valve', false)),
                  _act('Bật quạt hút', Icons.air,
                      () => s.setDevice('exhaustFan', true)),
                  _act('Bật bơm', Icons.water_drop_outlined,
                      () => s.setDevice('pump', true)),
                ],
              ),
            ] else ...[
              Text(
                'Chế độ TỰ ĐỘNG: firmware đang tự đóng van / bật quạt / bơm. '
                'Popup tắt khi hệ thống về an toàn.',
                style: NcText.body(size: 12.5, color: nc.whiteDim),
              ),
              const SizedBox(height: 10),
              GlowButton(
                label: 'Chuyển sang Thủ công',
                primary: false,
                icon: Icons.pan_tool_outlined,
                onPressed: () => s.setMode(DeviceMode.manual),
              ),
            ],
            const SizedBox(height: 12),
            Text(
              'Popup chỉ tắt khi đã hết nguy hiểm.',
              style: NcText.label(size: 10, color: nc.whiteDim),
            ),
          ],
        ),
      ),
    );
  }

  Widget _act(String label, IconData icon, VoidCallback onTap) => GlowButton(
        label: label,
        primary: false,
        icon: icon,
        onPressed: onTap,
      );
}
