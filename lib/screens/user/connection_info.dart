import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../state/app_state.dart';
import '../../theme/neon_carbon_colors.dart';
import '../../theme/neon_carbon_theme.dart';
import '../../widgets/tech_bracket_box.dart';

/// Panel thông tin kết nối & hệ thống (trạng thái demo/online, project...).
class ConnectionInfo extends StatelessWidget {
  const ConnectionInfo({super.key});

  @override
  Widget build(BuildContext context) {
    final demo = context.select<AppState, bool>((s) => s.isDemo);
    final rows = <(String, String)>[
      ('Trạng thái', demo ? 'DEMO (offline)' : 'TRỰC TUYẾN'),
      ('Project', 'smartkitchen-792f0'),
      ('Database', 'smartkitchen…rtdb'),
      ('Phiên bản', 'v1.0.0'),
    ];
    return TechBracketBox(
      child: Column(
        children: [
          for (final r in rows)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(r.$1, style: NcText.body(size: 12, color: context.nc.whiteDim)),
                  Text(
                    r.$2,
                    style: NcText.mono(
                      size: 10,
                      color: demo ? context.nc.amber : context.nc.cyanText,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
