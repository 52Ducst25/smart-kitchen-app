import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/main_shell.dart';
import 'services/firebase_service.dart';
import 'services/kitchen_data_source.dart';
import 'services/notification_service.dart';
import 'state/app_state.dart';
import 'state/theme_controller.dart';
import 'theme/neon_carbon_theme.dart';

/// Xử lý FCM khi app ở NỀN/ĐÓNG. Payload có 'notification' → hệ thống tự hiện
/// popup; không cần làm gì thêm ở đây (phải là hàm top-level, vm:entry-point).
@pragma('vm:entry-point')
Future<void> _firebaseBgHandler(RemoteMessage message) async {}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Khởi tạo Firebase; nếu lỗi/offline → tự lùi về demo mode.
  final source = await createKitchenSource();
  final prefs = await SharedPreferences.getInstance();
  // Cảnh báo đẩy (best-effort): đăng ký handler nền + khởi tạo dịch vụ thông báo.
  try {
    FirebaseMessaging.onBackgroundMessage(_firebaseBgHandler);
    await NotificationService.init();
  } catch (_) {}
  runApp(SafeKitchenApp(source: source, prefs: prefs));
}

class SafeKitchenApp extends StatelessWidget {
  const SafeKitchenApp({super.key, required this.source, required this.prefs});

  final KitchenDataSource source;
  final SharedPreferences prefs;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppState(source)..start()),
        ChangeNotifierProvider(create: (_) => ThemeController(prefs)),
      ],
      child: Consumer<ThemeController>(
        builder: (_, theme, _) => MaterialApp(
          title: 'Smart Kitchen',
          debugShowCheckedModeBanner: false,
          theme: NeonCarbonTheme.light,
          darkTheme: NeonCarbonTheme.dark,
          themeMode: theme.mode, // tự động / sáng / tối
          home: const MainShell(),
        ),
      ),
    );
  }
}
