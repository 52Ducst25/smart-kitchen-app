import 'package:flutter/material.dart';

import '../../models/settings.dart';
import '../../theme/neon_carbon_colors.dart';
import '../../theme/neon_carbon_theme.dart';
import '../../widgets/glow_button.dart';
import '../../widgets/tech_bracket_box.dart';

/// Form chỉnh 3 ngưỡng cảnh báo (gas/khói/nhiệt); lưu xuống Firebase qua [onSave].
/// Khởi tạo giá trị 1 lần từ [initial] để không ghi đè khi người dùng đang kéo.
class ThresholdForm extends StatefulWidget {
  const ThresholdForm({super.key, required this.initial, required this.onSave});

  final Settings initial;
  final Future<bool> Function(Settings) onSave;

  @override
  State<ThresholdForm> createState() => _ThresholdFormState();
}

class _ThresholdFormState extends State<ThresholdForm> {
  // Gas/khói theo ppm (giá trị ADC thô 0..4095); temp theo °C.
  late double _gas = widget.initial.gasTh.toDouble();
  late double _smoke = widget.initial.smokeTh.toDouble();
  late double _temp = widget.initial.tempTh;

  @override
  Widget build(BuildContext context) {
    return TechBracketBox(
      child: Column(
        children: [
          _slider('Ngưỡng Gas', _gas, 0, 4095, '${_gas.round()} ppm',
              (v) => setState(() => _gas = v)),
          _slider('Ngưỡng Khói', _smoke, 0, 4095, '${_smoke.round()} ppm',
              (v) => setState(() => _smoke = v)),
          _slider('Ngưỡng Nhiệt (°C)', _temp, 0, 80, '${_temp.round()}°C',
              (v) => setState(() => _temp = v)),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: GlowButton(
              label: 'Lưu',
              icon: Icons.save_outlined,
              onPressed: _save,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _save() async {
    final ok = await widget.onSave(
      Settings(
        gasTh: _gas.round(),
        smokeTh: _smoke.round(),
        tempTh: _temp.roundToDouble(),
      ),
    );
    if (!mounted) return;
    // Bảng thông báo báo kết quả lưu thành công / thất bại.
    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: context.nc.carbonPanel,
        icon: Icon(
          ok ? Icons.check_circle_outline : Icons.error_outline,
          color: ok ? context.nc.green : context.nc.red,
          size: 40,
        ),
        title: Text(
          ok ? 'Lưu thành công' : 'Lưu thất bại',
          textAlign: TextAlign.center,
          style: NcText.heading(size: 16, color: context.nc.white),
        ),
        content: Text(
          ok
              ? 'Đã cập nhật ngưỡng cảnh báo:\n'
                    'Gas ${_gas.round()} ppm • Khói ${_smoke.round()} ppm • Nhiệt ${_temp.round()}°C'
              : 'Không ghi được lên hệ thống. Kiểm tra kết nối mạng / '
                    'Firebase rồi thử lại.',
          textAlign: TextAlign.center,
          style: NcText.body(size: 13, color: context.nc.whiteDim),
        ),
        actions: [
          Center(
            child: TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text('OK', style: TextStyle(color: context.nc.cyan)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _slider(
    String label,
    double value,
    double min,
    double max,
    String display,
    ValueChanged<double> onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label.toUpperCase(), style: NcText.label(size: 10, color: context.nc.whiteDim)),
            Text(display, style: NcText.mono(size: 12, color: context.nc.cyanText)),
          ],
        ),
        Slider(
          value: value.clamp(min, max),
          min: min,
          max: max,
          activeColor: context.nc.cyan,
          inactiveColor: context.nc.carbonLineBright,
          onChanged: onChanged,
        ),
      ],
    );
  }
}
