import 'package:flutter/material.dart';

import '../../models/controls.dart';
import '../../theme/neon_carbon_colors.dart';
import '../../theme/neon_carbon_theme.dart';

/// Chuyển chế độ Auto / Manual (segmented). Auto = firmware tự điều khiển.
class ModeSwitcher extends StatelessWidget {
  const ModeSwitcher({super.key, required this.mode, required this.onChanged});

  final DeviceMode mode;
  final ValueChanged<DeviceMode> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _seg('TỰ ĐỘNG', DeviceMode.auto),
        const SizedBox(width: 1),
        _seg('THỦ CÔNG', DeviceMode.manual),
      ],
    );
  }

  Widget _seg(String label, DeviceMode m) {
    final active = mode == m;
    return Expanded(
      child: GestureDetector(
        onTap: () => onChanged(m),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: active ? NcColors.cyanDim : NcColors.carbonPanel,
            border: Border.all(
              color: active ? NcColors.cyan : NcColors.carbonLine,
            ),
          ),
          child: Text(
            label,
            style: NcText.label(
              size: 11,
              color: active ? NcColors.cyan : NcColors.whiteDim,
            ),
          ),
        ),
      ),
    );
  }
}
