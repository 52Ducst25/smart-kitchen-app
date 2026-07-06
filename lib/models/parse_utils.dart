/// Chuyển giá trị thô từ Firebase RTDB (int/double/String/bool/null) sang kiểu
/// mong muốn một cách an toàn — RTDB hay trả kiểu không nhất quán (1 vs "1").
library;

double asDouble(dynamic v, [double fallback = 0]) {
  if (v is num) return v.toDouble();
  if (v is String) return double.tryParse(v) ?? fallback;
  return fallback;
}

int asInt(dynamic v, [int fallback = 0]) {
  if (v is num) return v.round();
  if (v is String) {
    return int.tryParse(v) ?? (double.tryParse(v)?.round() ?? fallback);
  }
  return fallback;
}

bool asBool(dynamic v, [bool fallback = false]) {
  if (v is bool) return v;
  if (v is num) return v != 0;
  if (v is String) {
    final s = v.toLowerCase();
    return s == '1' || s == 'true' || s == 'on';
  }
  return fallback;
}
