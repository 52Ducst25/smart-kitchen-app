import 'package:flutter_test/flutter_test.dart';
import 'package:safe_kitchen_app/models/controls.dart';
import 'package:safe_kitchen_app/models/log_entry.dart';
import 'package:safe_kitchen_app/models/sensor_data.dart';
import 'package:safe_kitchen_app/models/settings.dart';

void main() {
  group('SensorData.fromMap', () {
    test('parse kiểu số/chuỗi lẫn lộn', () {
      final s = SensorData.fromMap({
        'temp': 30.5,
        'hum': '60',
        'gas': 400,
        'smoke': '250',
        'flame': 1,
      });
      expect(s.temp, 30.5);
      expect(s.hum, 60);
      expect(s.gas, 400);
      expect(s.smoke, 250);
      expect(s.flame, true);
    });

    test('map null → mặc định', () {
      final s = SensorData.fromMap(null);
      expect(s.temp, 0);
      expect(s.flame, false);
    });
  });

  group('Controls', () {
    test('mode chuỗi + cờ int/bool/string', () {
      final c = Controls.fromMap({
        'mode': 'manual',
        'valve': 1,
        'exhaustFan': 0,
        'coolFan': true,
        'pump': '1',
      });
      expect(c.isManual, true);
      expect(c.valve, true);
      expect(c.exhaustFan, false);
      expect(c.coolFan, true);
      expect(c.pump, true);
    });

    test('device() + copyWith', () {
      const c = Controls(valve: true);
      expect(c.device('valve'), true);
      expect(c.device('pump'), false);
      final c2 = c.copyWith(pump: true);
      expect(c2.pump, true);
      expect(c2.valve, true); // giữ nguyên trường khác
    });
  });

  group('Settings', () {
    test('parse + toMap', () {
      final s = Settings.fromMap({'gasTh': 500, 'smokeTh': 250, 'tempTh': 50});
      expect(s.gasTh, 500);
      expect(s.tempTh, 50);
      expect(s.toMap()['gasTh'], 500);
    });

    test('thiếu trường → mặc định', () {
      const s = Settings();
      expect(s.gasTh, 300);
      expect(s.smokeTh, 200);
      expect(s.tempTh, 45);
    });
  });

  group('LogEntry', () {
    test('parse mức nguy hiểm', () {
      expect(LogEntry.fromMap({'msg': 'x', 'level': 'danger'}).isDanger, true);
      expect(LogEntry.fromMap({'msg': 'y', 'level': 'info'}).isDanger, false);
    });
  });
}
