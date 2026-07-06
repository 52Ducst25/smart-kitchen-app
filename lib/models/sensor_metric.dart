import 'sensor_data.dart';

/// 5 chỉ số cảm biến hiển thị trên thẻ & biểu đồ. Mỗi chỉ số biết nhãn, đơn vị
/// và cách lấy GIÁ TRỊ ĐO THẬT từ [SensorData] (để vẽ đồ thị theo giá trị thật,
/// không quy về %). Lửa quy ước 1 = có, 0 = không.
enum SensorMetric {
  temp('Nhiệt độ', '°C'),
  hum('Độ ẩm', '%'),
  gas('Khí gas', 'ppm'),
  smoke('Khói', 'ppm'),
  flame('Lửa', '');

  const SensorMetric(this.label, this.unit);

  final String label;
  final String unit;

  /// Giá trị đo thật dùng cho biểu đồ (flame → 0/1).
  double valueOf(SensorData d) => switch (this) {
        SensorMetric.temp => d.temp,
        SensorMetric.hum => d.hum,
        SensorMetric.gas => d.gas.toDouble(),
        SensorMetric.smoke => d.smoke.toDouble(),
        SensorMetric.flame => d.flame ? 1 : 0,
      };
}
