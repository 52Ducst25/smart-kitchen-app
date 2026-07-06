import 'package:flutter/material.dart';

import '../../models/sensor_data.dart';
import '../../models/sensor_metric.dart';
import '../../models/settings.dart';
import '../../theme/neon_carbon_colors.dart';
import '../../widgets/stat_card.dart';

/// Màu nhấn theo chỉ số (dùng chung cho thẻ & biểu đồ) — DRY 1 nguồn.
Color metricAccent(NcPalette p, SensorMetric m) => switch (m) {
      SensorMetric.temp => p.mTemp,
      SensorMetric.hum => p.mHum,
      SensorMetric.gas => p.mGas,
      SensorMetric.smoke => p.mSmoke,
      SensorMetric.flame => p.mFlame,
    };

/// Lưới 5 thẻ cảm biến (nhiệt/ẩm/gas/khói/lửa); tô đỏ khi vượt ngưỡng.
/// Chạm 1 thẻ → gọi [onSelect] để mở biểu đồ chỉ số đó; [selected] để làm nổi.
class SensorGrid extends StatelessWidget {
  const SensorGrid({
    super.key,
    required this.data,
    required this.settings,
    required this.onSelect,
    this.selected,
  });

  final SensorData data;
  final Settings settings;
  final ValueChanged<SensorMetric> onSelect;
  final SensorMetric? selected;

  @override
  Widget build(BuildContext context) {
    final nc = context.nc;
    final cards = <Widget>[
      StatCard(
        id: SensorMetric.temp.label,
        value: data.temp.toStringAsFixed(1),
        unit: '°C',
        accent: metricAccent(nc, SensorMetric.temp),
        alert: data.temp > settings.tempTh,
        desc: 'Ngưỡng ${settings.tempTh.toStringAsFixed(0)}°C',
        selected: selected == SensorMetric.temp,
        onTap: () => onSelect(SensorMetric.temp),
      ),
      StatCard(
        id: SensorMetric.hum.label,
        value: data.hum.toStringAsFixed(0),
        unit: '%',
        accent: metricAccent(nc, SensorMetric.hum),
        desc: 'Môi trường',
        selected: selected == SensorMetric.hum,
        onTap: () => onSelect(SensorMetric.hum),
      ),
      StatCard(
        id: SensorMetric.gas.label,
        value: '${data.gas}',
        unit: 'ppm',
        accent: metricAccent(nc, SensorMetric.gas),
        alert: data.gas > settings.gasTh,
        desc: _level(data.gas, settings.gasTh),
        selected: selected == SensorMetric.gas,
        onTap: () => onSelect(SensorMetric.gas),
      ),
      StatCard(
        id: SensorMetric.smoke.label,
        value: '${data.smoke}',
        unit: 'ppm',
        accent: metricAccent(nc, SensorMetric.smoke),
        alert: data.smoke > settings.smokeTh,
        desc: _level(data.smoke, settings.smokeTh),
        selected: selected == SensorMetric.smoke,
        onTap: () => onSelect(SensorMetric.smoke),
      ),
      StatCard(
        id: SensorMetric.flame.label,
        value: data.flame ? 'CÓ' : 'KHÔNG',
        accent: metricAccent(nc, SensorMetric.flame),
        alert: data.flame,
        desc: data.flame ? 'Phát hiện!' : 'Không có lửa',
        selected: selected == SensorMetric.flame,
        onTap: () => onSelect(SensorMetric.flame),
      ),
    ];

    // mainAxisExtent cố định chiều cao thẻ → không bị kéo cao trên màn hình rộng.
    return GridView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 1,
        mainAxisSpacing: 1,
        mainAxisExtent: 138,
      ),
      children: cards,
    );
  }

  String _level(int v, int th) {
    if (v > th) return 'Vượt ngưỡng $th ppm';
    if (v > th * 0.75) return 'Gần ngưỡng';
    return 'An toàn';
  }
}
