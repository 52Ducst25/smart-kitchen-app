import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Cấu hình Firebase hand-write từ `Interface/app/firebaseConfig.js`
/// (project smartkitchen-792f0). Không cần flutterfire CLI / google-services.json.
///
/// Chỉ chứa WEB CLIENT CONFIG (không phải bí mật). KHÔNG nhúng WiFi password
/// hay Firebase legacy token của firmware ESP32 vào app.
class DefaultFirebaseOptions {
  DefaultFirebaseOptions._();

  static FirebaseOptions get currentPlatform {
    if (kIsWeb) return web;
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      default:
        // iOS/desktop chưa cấu hình riêng → dùng chung config (RTDB vẫn chạy).
        return web;
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyC_UbUNEDZcusag5aNa9tK_j05swsNXH3Y',
    appId: '1:555779970002:web:3bd31626a9f239d09d2e0b',
    messagingSenderId: '555779970002',
    projectId: 'smartkitchen-792f0',
    authDomain: 'smartkitchen-792f0.firebaseapp.com',
    databaseURL: 'https://smartkitchen-792f0-default-rtdb.firebaseio.com',
    storageBucket: 'smartkitchen-792f0.firebasestorage.app',
    measurementId: 'G-77YPV8DVM0',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyC_UbUNEDZcusag5aNa9tK_j05swsNXH3Y',
    appId: '1:555779970002:web:3bd31626a9f239d09d2e0b',
    messagingSenderId: '555779970002',
    projectId: 'smartkitchen-792f0',
    databaseURL: 'https://smartkitchen-792f0-default-rtdb.firebaseio.com',
    storageBucket: 'smartkitchen-792f0.firebasestorage.app',
  );
}
