import 'package:flutter/material.dart';

import '../../models/sensor_data.dart';
import '../../models/settings.dart';
import '../../theme/neon_carbon_colors.dart';
import '../../widgets/stat_card.dart';

/// Lưới 5 thẻ cảm biến (nhiệt/ẩm/gas/khói/lửa); tô đỏ khi vượt ngưỡng.
class SensorGrid extends StatelessWidget {
  const SensorGrid({super.key, required this.data, required this.settings});

  final SensorData data;
  final Settings settings;

  @override
  Widget build(BuildContext context) {
    final cards = <Widget>[
      StatCard(
        id: 'Nhiệt độ',
        value: data.temp.toStringAsFixed(1),
        unit: '°C',
        accent: NcColors.mTemp,
        alert: data.temp > settings.tempTh,
        desc: 'Ngưỡng ${settings.tempTh.toStringAsFixed(0)}°C',
      ),
      StatCard(
        id: 'Độ ẩm',
        value: data.hum.toStringAsFixed(0),
        unit: '%',
        accent: NcColors.mHum,
        desc: 'Môi trường',
      ),
      StatCard(
        id: 'Khí gas',
        value: '${data.gas}',
        unit: 'ppm',
        accent: NcColors.mGas,
        alert: data.gas > settings.gasTh,
        desc: _level(data.gas, settings.gasTh),
      ),
      StatCard(
        id: 'Khói',
        value: '${data.smoke}',
        unit: 'ppm',
        accent: NcColors.mSmoke,
        alert: data.smoke > settings.smokeTh,
        desc: _level(data.smoke, settings.smokeTh),
      ),
      StatCard(
        id: 'Lửa',
        value: data.flame ? 'CÓ' : 'KHÔNG',
        accent: NcColors.mFlame,
        alert: data.flame,
        desc: data.flame ? 'Phát hiện!' : 'Không có lửa',
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
