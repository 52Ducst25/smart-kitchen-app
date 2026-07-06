import 'dart:async';

import 'package:safe_kitchen_app/models/controls.dart';
import 'package:safe_kitchen_app/models/log_entry.dart';
import 'package:safe_kitchen_app/models/sensor_data.dart';
import 'package:safe_kitchen_app/models/settings.dart';
import 'package:safe_kitchen_app/services/kitchen_data_source.dart';

/// Nguồn dữ liệu giả cho test: không timer, phát giá trị theo lệnh và ghi lại
/// các thao tác điều khiển để kiểm chứng.
class FakeKitchenSource implements KitchenDataSource {
  final _sensors = StreamController<SensorData>.broadcast();
  final _controls = StreamController<Controls>.broadcast();
  final _settings = StreamController<Settings>.broadcast();
  final _logs = StreamController<List<LogEntry>>.broadcast();

  final List<String> deviceCalls = [];
  final List<DeviceMode> modeCalls = [];
  final List<Settings> settingsWrites = [];

  @override
  bool get isDemo => true;

  @override
  Stream<SensorData> get sensors => _sensors.stream;
  @override
  Stream<Controls> get controls => _controls.stream;
  @override
  Stream<Settings> get settings => _settings.stream;
  @override
  Stream<List<LogEntry>> get logs => _logs.stream;

  void emitSensors(SensorData s) => _sensors.add(s);
  void emitControls(Controls c) => _controls.add(c);
  void emitSettings(Settings s) => _settings.add(s);
  void emitLogs(List<LogEntry> l) => _logs.add(l);

  @override
  Future<void> setMode(DeviceMode mode) async => modeCalls.add(mode);
  @override
  Future<void> setDevice(String key, bool on) async =>
      deviceCalls.add('$key=$on');
  @override
  Future<void> updateSettings(Settings s) async => settingsWrites.add(s);
  @override
  Future<void> pushLog(LogEntry e) async {}

  @override
  void dispose() {
    _sensors.close();
    _controls.close();
    _settings.close();
    _logs.close();
  }
}
