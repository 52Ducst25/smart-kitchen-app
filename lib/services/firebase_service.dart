import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

import '../firebase_options.dart';
import '../models/controls.dart';
import '../models/log_entry.dart';
import '../models/sensor_data.dart';
import '../models/settings.dart';
import 'demo_data_source.dart';
import 'kitchen_data_source.dart';

/// Khởi tạo Firebase; nếu lỗi (chưa cấu hình/offline) → lùi về demo mode.
Future<KitchenDataSource> createKitchenSource() async {
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    return FirebaseKitchenSource();
  } catch (_) {
    return DemoKitchenSource();
  }
}

/// Nguồn dữ liệu thật qua Firebase Realtime Database (project smartkitchen-792f0).
class FirebaseKitchenSource implements KitchenDataSource {
  FirebaseKitchenSource() : _db = FirebaseDatabase.instance;

  final FirebaseDatabase _db;

  @override
  bool get isDemo => false;

  @override
  Stream<SensorData> get sensors => _db.ref('kitchen/sensors').onValue.map(
        (e) => SensorData.fromMap(_asMap(e.snapshot.value)),
      );

  @override
  Stream<Controls> get controls => _db.ref('kitchen/controls').onValue.map(
        (e) => Controls.fromMap(_asMap(e.snapshot.value)),
      );

  @override
  Stream<Settings> get settings => _db.ref('kitchen/settings').onValue.map(
        (e) => Settings.fromMap(_asMap(e.snapshot.value)),
      );

  @override
  Stream<List<LogEntry>> get logs =>
      _db.ref('kitchen/logs').limitToLast(8).onValue.map((e) {
        // Duyệt theo snapshot.children để tôn trọng thứ tự khoá (push id) —
        // xử lý được cả node dạng map push-key lẫn dạng mảng.
        final items = <LogEntry>[];
        for (final child in e.snapshot.children) {
          final v = child.value;
          if (v is Map) items.add(LogEntry.fromMap(v));
        }
        return items.reversed.toList(growable: false); // mới nhất lên đầu
      });

  @override
  Future<void> setMode(DeviceMode mode) =>
      _db.ref('kitchen/controls').update({'mode': mode.name});

  @override
  Future<void> setDevice(String key, bool on) =>
      _db.ref('kitchen/controls').update({key: on ? 1 : 0});

  @override
  Future<void> updateSettings(Settings settings) =>
      _db.ref('kitchen/settings').update(settings.toMap());

  @override
  Future<void> pushLog(LogEntry entry) =>
      _db.ref('kitchen/logs').push().set(entry.toMap());

  @override
  void dispose() {}

  static Map<dynamic, dynamic>? _asMap(Object? v) => v is Map ? v : null;
}
