import 'parse_utils.dart';

enum DeviceMode { auto, manual }

/// Trạng thái điều khiển từ node `kitchen/controls` (app ↔ firmware, realtime).
class Controls {
  const Controls({
    this.mode = DeviceMode.auto,
    this.valve = false,
    this.exhaustFan = false,
    this.coolFan = false,
    this.pump = false,
  });

  final DeviceMode mode;
  final bool valve; // van gas (servo)
  final bool exhaustFan; // quạt hút
  final bool coolFan; // quạt làm mát
  final bool pump; // bơm chữa cháy

  bool get isManual => mode == DeviceMode.manual;

  /// Đọc trạng thái 1 thiết bị theo key (khớp tên trường Firebase).
  bool device(String key) {
    switch (key) {
      case 'valve':
        return valve;
      case 'exhaustFan':
        return exhaustFan;
      case 'coolFan':
        return coolFan;
      case 'pump':
        return pump;
      default:
        return false;
    }
  }

  factory Controls.fromMap(Map<dynamic, dynamic>? map) {
    if (map == null) return const Controls();
    return Controls(
      mode: map['mode']?.toString() == 'manual'
          ? DeviceMode.manual
          : DeviceMode.auto,
      valve: asBool(map['valve']),
      exhaustFan: asBool(map['exhaustFan']),
      coolFan: asBool(map['coolFan']),
      pump: asBool(map['pump']),
    );
  }

  Controls copyWith({
    DeviceMode? mode,
    bool? valve,
    bool? exhaustFan,
    bool? coolFan,
    bool? pump,
  }) {
    return Controls(
      mode: mode ?? this.mode,
      valve: valve ?? this.valve,
      exhaustFan: exhaustFan ?? this.exhaustFan,
      coolFan: coolFan ?? this.coolFan,
      pump: pump ?? this.pump,
    );
  }
}
