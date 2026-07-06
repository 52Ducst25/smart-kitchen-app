import 'parse_utils.dart';

/// Dữ liệu cảm biến tức thời từ node `kitchen/sensors` (firmware đẩy 2s/lần).
class SensorData {
  const SensorData({
    this.temp = 0,
    this.hum = 0,
    this.gas = 0,
    this.smoke = 0,
    this.flame = false,
  });

  final double temp; // °C (DHT11)
  final double hum; // % (DHT11)
  final int gas; // MQ-4 analog 0..4095
  final int smoke; // MQ-2 analog 0..4095
  final bool flame; // cảm biến lửa

  factory SensorData.fromMap(Map<dynamic, dynamic>? map) {
    if (map == null) return const SensorData();
    return SensorData(
      temp: asDouble(map['temp']),
      hum: asDouble(map['hum']),
      gas: asInt(map['gas']),
      smoke: asInt(map['smoke']),
      flame: asBool(map['flame']),
    );
  }
}
