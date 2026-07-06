import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app/main_shell.dart';
import 'services/firebase_service.dart';
import 'services/kitchen_data_source.dart';
import 'state/app_state.dart';
import 'theme/neon_carbon_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Khởi tạo Firebase; nếu lỗi/offline → tự lùi về demo mode.
  final source = await createKitchenSource();
  runApp(SafeKitchenApp(source: source));
}

class SafeKitchenApp extends StatelessWidget {
  const SafeKitchenApp({super.key, required this.source});

  final KitchenDataSource source;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppState(source)..start(),
      child: MaterialApp(
        title: 'Smart Kitchen',
        debugShowCheckedModeBanner: false,
        theme: NeonCarbonTheme.dark,
        home: const MainShell(),
      ),
    );
  }
}
