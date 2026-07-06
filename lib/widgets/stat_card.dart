import 'package:flutter/material.dart';

import '../theme/neon_carbon_colors.dart';
import '../theme/neon_carbon_theme.dart';
import 'tech_bracket_box.dart';

/// Thẻ số liệu Neon-Carbon (guideline §5): id (nhãn mono) + value .unit + desc.
/// [alert]=true → tô đỏ + glow (vượt ngưỡng). [accent] override màu value.
class StatCard extends StatelessWidget {
  const StatCard({
    super.key,
    required this.id,
    required this.value,
    this.unit,
    this.desc,
    this.alert = false,
    this.accent,
    this.onTap,
    this.selected = false,
  });

  final String id;
  final String value;
  final String? unit;
  final String? desc;
  final bool alert;
  final Color? accent;

  /// Bấm vào thẻ (vd để mở biểu đồ của chỉ số này). Null = không bắt sự kiện.
  final VoidCallback? onTap;

  /// Đang được chọn (đang xem biểu đồ) → làm nổi bằng glow cyan.
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final valueColor = alert ? context.nc.red : (accent ?? context.nc.white);
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: TechBracketBox(
        // Viền nhấn chỉ khi cảnh báo (đỏ) hoặc đang chọn (tím); mặc định trung tính.
        bracketColor: alert
            ? context.nc.red
            : (selected ? context.nc.cyan : null),
        glow: alert || selected,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(id.toUpperCase(), style: NcText.label(color: context.nc.whiteDim)),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Flexible(
                  child: Text(
                    value,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: NcText.value(color: valueColor),
                  ),
                ),
                if (unit != null) ...[
                  const SizedBox(width: 4),
                  Text(unit!, style: NcText.label(size: 11, color: context.nc.whiteDim)),
                ],
              ],
            ),
          ),
          if (desc != null)
            Text(
              desc!,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: NcText.body(size: 11, color: context.nc.whiteDim),
            ),
          ],
        ),
      ),
    );
  }
}
