import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/update_service.dart';
import '../../state/app_state.dart';
import '../../state/theme_controller.dart';
import '../../theme/neon_carbon_colors.dart';
import '../../theme/neon_carbon_theme.dart';
import '../../widgets/glow_button.dart';
import '../../widgets/hud_header.dart';
import '../../widgets/section_label.dart';
import '../../widgets/update_dialog.dart';
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
        const SectionLabel('Cập nhật'),
        const SizedBox(height: 10),
        const _UpdateCheckButton(),
        const SizedBox(height: 20),
        const SectionLabel('Kết nối'),
        const SizedBox(height: 10),
        const ConnectionInfo(),
      ],
    );
  }
}

/// Nút kiểm tra cập nhật thủ công — hiện kết quả rõ ràng (có bản mới → popup,
/// đã mới nhất → thông báo, lỗi → hiện lý do). Bổ trợ cho lần tự kiểm khi mở app.
class _UpdateCheckButton extends StatefulWidget {
  const _UpdateCheckButton();

  @override
  State<_UpdateCheckButton> createState() => _UpdateCheckButtonState();
}

class _UpdateCheckButtonState extends State<_UpdateCheckButton> {
  final _service = UpdateService();
  bool _checking = false;

  Future<void> _check() async {
    setState(() => _checking = true);
    final messenger = ScaffoldMessenger.of(context);
    try {
      final info = await _service.check();
      if (!mounted) return;
      if (info == null) {
        messenger.showSnackBar(
          const SnackBar(content: Text('Đang dùng bản mới nhất.')),
        );
      } else {
        await UpdateDialog.show(context, info, _service);
      }
    } catch (e) {
      if (!mounted) return;
      messenger.showSnackBar(
        SnackBar(content: Text('Lỗi kiểm tra cập nhật: $e')),
      );
    } finally {
      if (mounted) setState(() => _checking = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: GlowButton(
        label: _checking ? 'Đang kiểm tra…' : 'Kiểm tra cập nhật',
        icon: Icons.system_update,
        onPressed: _checking ? null : _check,
      ),
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
