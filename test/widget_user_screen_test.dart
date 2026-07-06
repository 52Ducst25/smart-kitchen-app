import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:safe_kitchen_app/models/settings.dart';
import 'package:safe_kitchen_app/screens/user/user_screen.dart';
import 'package:safe_kitchen_app/state/app_state.dart';
import 'package:safe_kitchen_app/theme/neon_carbon_theme.dart';

import 'helpers/fake_kitchen_source.dart';

void main() {
  setUpAll(() => GoogleFonts.config.allowRuntimeFetching = false);

  testWidgets('Form chờ settings & nạp lại khi ngưỡng đổi (H1 regression)',
      (tester) async {
    final fake = FakeKitchenSource();
    final state = AppState(fake)..start();

    await tester.pumpWidget(
      ChangeNotifierProvider<AppState>.value(
        value: state,
        child: MaterialApp(
          theme: NeonCarbonTheme.dark,
          home: const Scaffold(body: UserScreen()),
        ),
      ),
    );

    // Chưa có settings → hiện loader, chưa dựng form (tránh ghi đè bằng default).
    await tester.pump();
    expect(find.text('Đang tải ngưỡng…'), findsOneWidget);

    fake.emitSettings(const Settings(gasTh: 300, smokeTh: 200, tempTh: 45));
    await tester.pump();
    await tester.pump();
    expect(find.text('300 ppm'), findsOneWidget);

    // Ngưỡng thật đổi → form nạp giá trị mới (không giữ 300 cũ).
    fake.emitSettings(const Settings(gasTh: 1000, smokeTh: 200, tempTh: 45));
    await tester.pump();
    await tester.pump();
    expect(find.text('1000 ppm'), findsOneWidget);
    expect(find.text('300 ppm'), findsNothing);

    state.dispose();
  });
}
