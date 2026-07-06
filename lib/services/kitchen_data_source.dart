import '../models/controls.dart';
import '../models/log_entry.dart';
import '../models/sensor_data.dart';
import '../models/settings.dart';

/// Giao diện nguồn dữ liệu bếp — cho phép hoán đổi Firebase thật ↔ demo/mock
/// (phục vụ chạy offline và widget test không cần Firebase).
abstract class KitchenDataSource {
  bool get isDemo;

  Stream<SensorData> get sensors;
  Stream<Controls> get controls;
  Stream<Settings> get settings;
  Stream<List<LogEntry>> get logs;

  Future<void> setMode(DeviceMode mode);
  Future<void> setDevice(String key, bool on);
  Future<void> updateSettings(Settings settings);
  Future<void> pushLog(LogEntry entry);

  void dispose();
}
