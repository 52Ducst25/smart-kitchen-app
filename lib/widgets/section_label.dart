import 'package:flutter/material.dart';

import '../theme/neon_carbon_colors.dart';
import '../theme/neon_carbon_theme.dart';

/// Nhãn khu vực kỹ thuật: gạch cyan + chữ UPPERCASE mono giãn cách rộng (§2).
class SectionLabel extends StatelessWidget {
  const SectionLabel(this.text, {super.key, this.color = NcColors.whiteDim});

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(width: 10, height: 1.5, color: NcColors.cyan),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text.toUpperCase(),
            style: NcText.label(color: color),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
