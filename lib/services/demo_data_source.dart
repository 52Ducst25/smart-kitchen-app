import 'dart:async';
import 'dart:math';

import '../models/controls.dart';
import '../models/log_entry.dart';
import '../models/sensor_data.dart';
import '../models/settings.dart';
import 'kitchen_data_source.dart';

/// Nguồn dữ liệu giả lập (không nối Firebase) — dùng khi chưa cấu hình/offline
/// hoặc trong test. Phát số liệu cảm biến biến thiên nhẹ mỗi 2s; giữ
/// controls/settings trong bộ nhớ để thao tác điều khiển vẫn phản hồi.
class DemoKitchenSource implements KitchenDataSource {
  DemoKitchenSource() {
    _timer = Timer.periodic(const Duration(seconds: 2), (_) => _emit());
    _emit();
  }

  final _rng = Random(42);
  Timer? _timer;

  final _sensorsCtrl = StreamController<SensorData>.broadcast();
  final _controlsCtrl = StreamController<Controls>.broadcast();
  final _settingsCtrl = StreamController<Settings>.broadcast();
  final _logsCtrl = StreamController<List<LogEntry>>.broadcast();

  Controls _controls = const Controls();
  Settings _settings = const Settings();
  final List<LogEntry> _logs = [
    const LogEntry(
      msg: 'Demo: khu vực bếp an toàn',
      level: LogLevel.info,
      time: '0s',
    ),
  ];

  @override
  bool get isDemo => true;

  void _emit() {
    final t = 28 + _rng.nextDouble() * 6; // 28..34 °C
    _sensorsCtrl.add(
      SensorData(
        temp: double.parse(t.toStringAsFixed(1)),
        hum: 55 + _rng.nextDouble() * 15,
        gas: 120 + _rng.nextInt(120),
        smoke: 80 + _rng.nextInt(100),
        flame: false,
      ),
    );
    _controlsCtrl.add(_controls);
    _settingsCtrl.add(_settings);
    _logsCtrl.add(List.unmodifiable(_logs));
  }

  @override
  Stream<SensorData> get sensors => _sensorsCtrl.stream;
  @override
  Stream<Controls> get controls => _controlsCtrl.stream;
  @override
  Stream<Settings> get settings => _settingsCtrl.stream;
  @override
  Stream<List<LogEntry>> get logs => _logsCtrl.stream;

  @override
  Future<void> setMode(DeviceMode mode) async {
    _controls = _controls.copyWith(mode: mode);
    _controlsCtrl.add(_controls);
  }

  @override
  Future<void> setDevice(String key, bool on) async {
    _controls = _controls.copyWith(
      valve: key == 'valve' ? on : null,
      exhaustFan: key == 'exhaustFan' ? on : null,
      coolFan: key == 'coolFan' ? on : null,
      pump: key == 'pump' ? on : null,
    );
    _controlsCtrl.add(_controls);
  }

  @override
  Future<void> updateSettings(Settings settings) async {
    _settings = settings;
    _settingsCtrl.add(_settings);
  }

  @override
  Future<void> pushLog(LogEntry entry) async {
    _logs.insert(0, entry);
    _logsCtrl.add(List.unmodifiable(_logs));
  }

  @override
  void dispose() {
    _timer?.cancel();
    _sensorsCtrl.close();
    _controlsCtrl.close();
    _settingsCtrl.close();
    _logsCtrl.close();
  }
}
