import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../models/sensor_data.dart';
import '../../theme/neon_carbon_colors.dart';
import '../../theme/neon_carbon_theme.dart';
import '../../utils/adc_scale.dart';
import '../../widgets/tech_bracket_box.dart';

/// Connected Scatterplot: mỗi điểm đo là 1 chấm, nối nhau bằng đoạn thẳng.
/// 4 chỉ số được chuẩn hoá về thang 0–100% để so sánh cùng 1 trục:
/// Nhiệt (/80°C), Ẩm (%), Gas (/4095), Khói (/4095).
class SensorHistoryChart extends StatelessWidget {
  const SensorHistoryChart({super.key, required this.history});

  final List<SensorData> history;

  @override
  Widget build(BuildContext context) {
    if (history.length < 2) {
      return TechBracketBox(
        child: SizedBox(
          height: 200,
          child: Center(
            child: Text(
              'Đang thu thập dữ liệu…',
              style: NcText.body(color: context.nc.whiteDim),
            ),
          ),
        ),
      );
    }

    final series = <_Series>[
      _Series('Nhiệt', context.nc.mTemp, _spots((d) => d.temp / 80 * 100)),
      _Series('Ẩm', context.nc.mHum, _spots((d) => d.hum)),
      _Series('Gas', context.nc.mGas, _spots((d) => adcToPercent(d.gas).toDouble())),
      _Series('Khói', context.nc.mSmoke, _spots((d) => adcToPercent(d.smoke).toDouble())),
    ];

    return TechBracketBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('% THANG ĐO (0–100)', style: NcText.label(size: 9, color: context.nc.whiteDim)),
          const SizedBox(height: 10),
          Wrap(
            spacing: 14,
            runSpacing: 6,
            children: [for (final s in series) _legend(context, s.color, s.label)],
          ),
          const SizedBox(height: 14),
          SizedBox(
            height: 200,
            child: LineChart(
              LineChartData(
                minY: 0,
                maxY: 100,
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 25,
                  getDrawingHorizontalLine: (v) =>
                      FlLine(color: context.nc.carbonLine, strokeWidth: 1),
                ),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 25,
                      reservedSize: 26,
                      getTitlesWidget: (v, m) => Text(
                        v.toInt().toString(),
                        style: NcText.mono(size: 8, color: context.nc.whiteDim),
                      ),
                    ),
                  ),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(show: false),
                lineTouchData: const LineTouchData(enabled: false),
                lineBarsData: [for (final s in series) _bar(s)],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<FlSpot> _spots(double Function(SensorData) f) => [
        for (var i = 0; i < history.length; i++)
          FlSpot(i.toDouble(), f(history[i]).clamp(0, 100).toDouble()),
      ];

  LineChartBarData _bar(_Series s) => LineChartBarData(
        spots: s.spots,
        isCurved: false, // đoạn thẳng nối điểm = connected scatterplot
        color: s.color,
        barWidth: 1.4,
        dotData: FlDotData(
          show: true,
          getDotPainter: (spot, pct, bar, i) =>
              FlDotCirclePainter(radius: 2.4, color: s.color, strokeWidth: 0),
        ),
      );

  Widget _legend(BuildContext context, Color c, String label) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: c, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Text(label, style: NcText.label(size: 9, color: context.nc.whiteDim)),
        ],
      );
}

class _Series {
  const _Series(this.label, this.color, this.spots);

  final String label;
  final Color color;
  final List<FlSpot> spots;
}
