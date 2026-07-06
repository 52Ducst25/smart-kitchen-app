import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Quản lý chế độ giao diện (tự động theo hệ thống / sáng / tối) và lưu lựa
/// chọn qua SharedPreferences để giữ nguyên sau khi mở lại app.
class ThemeController extends ChangeNotifier {
  ThemeController(this._prefs) : _mode = _decode(_prefs.getString(_key));

  static const _key = 'theme_mode';
  final SharedPreferences _prefs;
  ThemeMode _mode;

  ThemeMode get mode => _mode;

  Future<void> setMode(ThemeMode mode) async {
    if (mode == _mode) return;
    _mode = mode;
    notifyListeners();
    await _prefs.setString(_key, mode.name);
  }

  static ThemeMode _decode(String? v) {
    switch (v) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      case 'system':
        return ThemeMode.system; // user chọn Tự động → giữ Tự động
      default:
        return ThemeMode.light; // mặc định lần đầu (chưa chọn) = Sáng
    }
  }
}
