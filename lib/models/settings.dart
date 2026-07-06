import 'parse_utils.dart';

/// Ngưỡng cảnh báo từ node `kitchen/settings` (app ghi, firmware poll 5s).
class Settings {
  const Settings({this.gasTh = 300, this.smokeTh = 200, this.tempTh = 45});

  final int gasTh; // ngưỡng gas (raw)
  final int smokeTh; // ngưỡng khói (raw)
  final double tempTh; // ngưỡng nhiệt (°C)

  factory Settings.fromMap(Map<dynamic, dynamic>? map) {
    if (map == null) return const Settings();
    return Settings(
      gasTh: asInt(map['gasTh'], 300),
      smokeTh: asInt(map['smokeTh'], 200),
      tempTh: asDouble(map['tempTh'], 45),
    );
  }

  Map<String, Object> toMap() => {
        'gasTh': gasTh,
        'smokeTh': smokeTh,
        'tempTh': tempTh,
      };

  Settings copyWith({int? gasTh, int? smokeTh, double? tempTh}) => Settings(
        gasTh: gasTh ?? this.gasTh,
        smokeTh: smokeTh ?? this.smokeTh,
        tempTh: tempTh ?? this.tempTh,
      );

  // So sánh theo giá trị: dùng làm ValueKey cho form để form tự nạp lại khi
  // ngưỡng thật từ Firebase về, nhưng không reset khi người dùng đang kéo slider.
  @override
  bool operator ==(Object other) =>
      other is Settings &&
      other.gasTh == gasTh &&
      other.smokeTh == smokeTh &&
      other.tempTh == tempTh;

  @override
  int get hashCode => Object.hash(gasTh, smokeTh, tempTh);
}
