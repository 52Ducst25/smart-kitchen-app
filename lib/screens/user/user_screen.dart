import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../state/app_state.dart';
import '../../state/theme_controller.dart';
import '../../theme/neon_carbon_colors.dart';
import '../../theme/neon_carbon_theme.dart';
import '../../widgets/hud_header.dart';
import '../../widgets/section_label.dart';
import 'connection_info.dart';
import 'threshold_form.dart';

/// Tab User — cài ngưỡng cảnh báo + giao diện + thông tin hệ thống/kết nối.
class UserScreen extends StatelessWidget {
  const UserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = context.watch<AppState>();
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        HudHeader(
          title: 'Cài đặt',
          subtitle: 'NGƯỠNG CẢNH BÁO & HỆ THỐNG',
          statusColor: s.isDanger ? context.nc.red : context.nc.green,
          demo: s.isDemo,
        ),
        const SizedBox(height: 16),
        const SectionLabel('Ngưỡng cảnh báo'),
        const SizedBox(height: 10),
        // Chờ ngưỡng thật từ Firebase trước khi dựng form, tránh nạp giá trị
        // mặc định rồi lỡ ghi đè cấu hình thiết bị. ValueKey(settings) khiến
        // form tự nạp lại khi ngưỡng đổi, nhưng giữ nguyên khi đang kéo slider.
        if (!s.settingsLoaded)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Center(
              child: Text(
                'Đang tải ngưỡng…',
                style: NcText.body(color: context.nc.whiteDim),
              ),
            ),
          )
        else
          ThresholdForm(
            key: ValueKey(s.settings),
            initial: s.settings,
            onSave: s.updateSettings,
          ),
        const SizedBox(height: 20),
        const SectionLabel('Giao diện'),
        const SizedBox(height: 10),
        const _ThemeModeSelector(),
        const SizedBox(height: 20),
        const SectionLabel('Kết nối'),
        const SizedBox(height: 10),
        const ConnectionInfo(),
      ],
    );
  }
}

/// Bộ chọn chế độ giao diện: Tự động (theo hệ thống) / Sáng / Tối.
class _ThemeModeSelector extends StatelessWidget {
  const _ThemeModeSelector();

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<ThemeController>();
    return SegmentedButton<ThemeMode>(
      showSelectedIcon: false,
      style: SegmentedButton.styleFrom(
        foregroundColor: context.nc.whiteDim,
        selectedForegroundColor: context.nc.cyan,
        selectedBackgroundColor: context.nc.cyanDim,
        side: BorderSide(color: context.nc.carbonLine),
      ),
      segments: const [
        ButtonSegment(
          value: ThemeMode.system,
          icon: Icon(Icons.brightness_auto_outlined),
          label: Text('Tự động'),
        ),
        ButtonSegment(
          value: ThemeMode.light,
          icon: Icon(Icons.light_mode_outlined),
          label: Text('Sáng'),
        ),
        ButtonSegment(
          value: ThemeMode.dark,
          icon: Icon(Icons.dark_mode_outlined),
          label: Text('Tối'),
        ),
      ],
      selected: {controller.mode},
      onSelectionChanged: (set) => controller.setMode(set.first),
    );
  }
}
