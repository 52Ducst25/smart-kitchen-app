import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../models/sensor_data.dart';
import '../../models/sensor_metric.dart';
import '../../theme/neon_carbon_colors.dart';
import '../../theme/neon_carbon_theme.dart';
import '../../widgets/tech_bracket_box.dart';

/// Biểu đồ 1 chỉ số theo GIÁ TRỊ ĐO THẬT (không quy về %). Trục Y tự co giãn
/// theo khoảng dữ liệu thực tế; điểm nối nhau kiểu connected scatterplot.
class MetricHistoryChart extends StatelessWidget {
  const MetricHistoryChart({
    super.key,
    required this.history,
    required this.metric,
    required this.color,
  });

  final List<SensorData> history;
  final SensorMetric metric;
  final Color color;

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

    final values = [for (final d in history) metric.valueOf(d)];
    final isFlame = metric == SensorMetric.flame;

    // Trục Y: tự co giãn theo khoảng dữ liệu + đệm 15% cho thoáng; lửa cố định 0–1.
    double minY, maxY;
    if (isFlame) {
      minY = -0.2;
      maxY = 1.2;
    } else {
      var lo = values.reduce(min);
      var hi = values.reduce(max);
      if ((hi - lo).abs() < 1e-6) {
        lo -= 1;
        hi += 1;
      }
      final pad = (hi - lo) * 0.15;
      minY = lo - pad;
      maxY = hi + pad;
    }
    final interval = max((maxY - minY) / 4, 0.0001);
    final decimals = (maxY - minY) < 10 ? 1 : 0;

    String fmtAxis(double v) {
      if (isFlame) {
        if (v >= 0.8) return 'Có';
        if (v <= 0.2) return 'Không';
        return '';
      }
      return v.toStringAsFixed(decimals);
    }

    final latest = values.last;
    final latestLabel = isFlame
        ? (latest >= 0.5 ? 'CÓ' : 'KHÔNG')
        : latest.toStringAsFixed(decimals);

    final spots = [
      for (var i = 0; i < values.length; i++) FlSpot(i.toDouble(), values[i]),
    ];

    return TechBracketBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              ),
              const SizedBox(width: 8),
              Text(
                metric.label.toUpperCase(),
                style: NcText.label(size: 10, color: context.nc.whiteDim),
              ),
              const Spacer(),
              Text(latestLabel, style: NcText.mono(size: 14, color: color)),
              if (metric.unit.isNotEmpty) ...[
                const SizedBox(width: 4),
                Text(
                  metric.unit,
                  style: NcText.label(size: 10, color: context.nc.whiteDim),
                ),
              ],
            ],
          ),
          const SizedBox(height: 14),
          SizedBox(
            height: 200,
            child: LineChart(
              LineChartData(
                minY: minY,
                maxY: maxY,
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: interval,
                  getDrawingHorizontalLine: (v) =>
                      FlLine(color: context.nc.carbonLine, strokeWidth: 1),
                ),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: interval,
                      reservedSize: 40,
                      getTitlesWidget: (v, m) => Text(
                        fmtAxis(v),
                        style: NcText.mono(size: 8, color: context.nc.whiteDim),
                      ),
                    ),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                borderData: FlBorderData(show: false),
                lineTouchData: const LineTouchData(enabled: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: false, // đoạn thẳng nối điểm = connected scatterplot
                    color: color,
                    barWidth: 1.6,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, pct, bar, i) =>
                          FlDotCirclePainter(radius: 2.4, color: color, strokeWidth: 0),
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      color: color.withValues(alpha: 0.08),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
