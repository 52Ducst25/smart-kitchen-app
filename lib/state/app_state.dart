import 'dart:async';
import 'dart:collection';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

import '../models/controls.dart';
import '../models/log_entry.dart';
import '../models/sensor_data.dart';
import '../models/settings.dart';
import '../services/kitchen_data_source.dart';

/// State trung tâm: gộp 4 luồng dữ liệu bếp + lịch sử chart + logic cảnh báo.
/// UI dùng qua `context.watch<AppState>()`.
class AppState extends ChangeNotifier {
  AppState(this._source);

  final KitchenDataSource _source;
  final _subs = <StreamSubscription<dynamic>>[];

  SensorData _sensors = const SensorData();
  Controls _controls = const Controls();
  Settings _settings = const Settings();
  List<LogEntry> _logs = const [];
  bool _settingsLoaded = false; // đã nhận ngưỡng thật lần đầu chưa

  // Chế độ dữ liệu mẫu (demo overlay): tự sinh số liệu để xem biểu đồ có thông số.
  bool _demoMode = false;
  Timer? _demoTimer;
  final Random _demoRng = Random(7);

  // Ring buffer lịch sử để vẽ chart (RTDB chỉ có giá trị tức thời).
  static const _historyMax = 30;
  final ListQueue<SensorData> _history = ListQueue();

  SensorData get sensors => _sensors;
  Controls get controls => _controls;
  Settings get settings => _settings;
  List<LogEntry> get logs => _logs;
  bool get isDemo => _source.isDemo;
  bool get settingsLoaded => _settingsLoaded;
  bool get demoMode => _demoMode;
  List<SensorData> get history => _history.toList(growable: false);

  /// Bắt đầu lắng nghe các luồng dữ liệu.
  void start() {
    _subs.add(_source.sensors.listen((s) {
      if (_demoMode) return; // demo overlay đang chiếm quyền hiển thị
      _sensors = s;
      _history.addLast(s);
      while (_history.length > _historyMax) {
        _history.removeFirst();
      }
      notifyListeners();
    }, onError: _onStreamError));
    _subs.add(_source.controls.listen((c) {
      _controls = c;
      notifyListeners();
    }, onError: _onStreamError));
    _subs.add(_source.settings.listen((s) {
      _settings = s;
      _settingsLoaded = true;
      notifyListeners();
    }, onError: _onStreamError));
    _subs.add(_source.logs.listen((l) {
      _logs = l;
      notifyListeners();
    }, onError: _onStreamError));
  }

  void _onStreamError(Object e, StackTrace st) =>
      debugPrint('AppState stream error: $e');

  // --- Logic cảnh báo nguy hiểm (tính ở client để tô UI) ---
  bool get isDanger =>
      _sensors.flame ||
      _sensors.gas > _settings.gasTh ||
      _sensors.smoke > _settings.smokeTh ||
      _sensors.temp > _settings.tempTh;

  List<String> get activeAlerts {
    final a = <String>[];
    if (_sensors.flame) a.add('Phát hiện lửa');
    if (_sensors.gas > _settings.gasTh) {
      a.add('Gas ${_sensors.gas} > ${_settings.gasTh} ppm');
    }
    if (_sensors.smoke > _settings.smokeTh) {
      a.add('Khói ${_sensors.smoke} > ${_settings.smokeTh} ppm');
    }
    if (_sensors.temp > _settings.tempTh) {
      a.add(
        'Nhiệt ${_sensors.temp.toStringAsFixed(1)}°C > ${_settings.tempTh.toStringAsFixed(0)}°C',
      );
    }
    return a;
  }

  // --- Hành động điều khiển (ghi xuống Firebase) ---
  // Bọc _guard để lỗi ghi (mất mạng/quyền) không thành lỗi async chưa bắt.
  // Sau khi ghi, đẩy 1 dòng nhật ký để phản ánh thao tác thủ công của người dùng
  // (trước đây chỉ ghi controls nên nhật ký không cập nhật khi bật/tắt thiết bị).
  Future<void> setMode(DeviceMode mode) async {
    await _guard(() => _source.setMode(mode));
    await pushLog(LogEntry(
      msg: mode == DeviceMode.manual
          ? 'Chuyển chế độ Thủ công'
          : 'Chuyển chế độ Tự động',
      time: _timeLabel(),
    ));
  }

  Future<void> setDevice(String key, bool on) async {
    await _guard(() => _source.setDevice(key, on));
    await pushLog(LogEntry(
      msg: '${_deviceAction(key, on)} (thủ công)',
      time: _timeLabel(),
    ));
  }

  /// Trả về true nếu ghi thành công, false nếu lỗi (để UI báo người dùng).
  Future<bool> updateSettings(Settings s) =>
      _guardBool(() => _source.updateSettings(s));
  Future<void> pushLog(LogEntry e) => _guard(() => _source.pushLog(e));

  static String _timeLabel() => DateFormat('HH:mm').format(DateTime.now());

  /// Mô tả thao tác theo khoá thiết bị (van dùng "Mở/Đóng", còn lại "Bật/Tắt").
  static String _deviceAction(String key, bool on) {
    switch (key) {
      case 'valve':
        return on ? 'Mở van gas' : 'Đóng van gas';
      case 'exhaustFan':
        return on ? 'Bật quạt hút' : 'Tắt quạt hút';
      case 'coolFan':
        return on ? 'Bật quạt làm mát' : 'Tắt quạt làm mát';
      case 'pump':
        return on ? 'Bật bơm nước' : 'Tắt bơm nước';
      default:
        return on ? 'Bật $key' : 'Tắt $key';
    }
  }

  Future<void> _guard(Future<void> Function() action) async {
    try {
      await action();
    } catch (e) {
      debugPrint('AppState write error: $e');
    }
  }

  Future<bool> _guardBool(Future<void> Function() action) async {
    try {
      await action();
      return true;
    } catch (e) {
      debugPrint('AppState write error: $e');
      return false;
    }
  }

  // --- Chế độ dữ liệu mẫu (demo overlay) ---
  /// Bật/tắt tự sinh số liệu cảm biến để xem biểu đồ (không đụng Firebase thật).
  void toggleDemo(bool on) {
    _demoMode = on;
    _demoTimer?.cancel();
    if (on) {
      if (!_settingsLoaded) {
        _settings = const Settings();
        _settingsLoaded = true;
      }
      _demoTimer =
          Timer.periodic(const Duration(seconds: 10), (_) => _emitDemo());
      _emitDemo();
    }
    notifyListeners();
  }

  void _emitDemo() {
    // Random walk quanh vùng an toàn, thỉnh thoảng vọt lên để thấy cảnh báo.
    final spike = _demoRng.nextInt(12) == 0;
    _sensors = SensorData(
      temp: 30 + _demoRng.nextDouble() * (spike ? 22 : 8),
      hum: 55 + _demoRng.nextDouble() * 20,
      gas: 150 + _demoRng.nextInt(spike ? 380 : 120),
      smoke: 100 + _demoRng.nextInt(spike ? 240 : 100),
      flame: spike && _demoRng.nextBool(),
    );
    _history.addLast(_sensors);
    while (_history.length > _historyMax) {
      _history.removeFirst();
    }
    notifyListeners();
  }

  @override
  void dispose() {
    _demoTimer?.cancel();
    for (final s in _subs) {
      s.cancel();
    }
    _source.dispose();
    super.dispose();
  }
}
