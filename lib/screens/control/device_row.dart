import 'package:flutter/material.dart';

import '../../theme/neon_carbon_colors.dart';
import '../../theme/neon_carbon_theme.dart';
import '../../widgets/tech_bracket_box.dart';

/// Một hàng điều khiển thiết bị: icon + tên + mô tả trạng thái + Switch.
/// [enabled]=false (chế độ Auto) → khoá switch, ghi chú "Tự động điều khiển".
class DeviceRow extends StatelessWidget {
  const DeviceRow({
    super.key,
    required this.icon,
    required this.name,
    required this.on,
    required this.onDesc,
    required this.offDesc,
    required this.enabled,
    required this.onChanged,
  });

  final IconData icon;
  final String name;
  final bool on;
  final String onDesc;
  final String offDesc;
  final bool enabled;
  final ValueChanged<bool>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TechBracketBox(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        bracketColor: on ? NcColors.cyan : NcColors.carbonLineBright,
        child: Row(
          children: [
            Icon(icon, color: on ? NcColors.cyan : NcColors.whiteDim, size: 22),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: NcText.body(size: 14, color: NcColors.white)),
                  const SizedBox(height: 2),
                  Text(
                    enabled ? (on ? onDesc : offDesc) : 'Tự động điều khiển',
                    style: NcText.label(
                      size: 9,
                      color: on ? NcColors.cyanText : NcColors.whiteDim,
                    ),
                  ),
                ],
              ),
            ),
            Switch(value: on, onChanged: enabled ? onChanged : null),
          ],
        ),
      ),
    );
  }
}
