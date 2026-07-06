import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:safe_kitchen_app/models/sensor_data.dart';
import 'package:safe_kitchen_app/models/settings.dart';
import 'package:safe_kitchen_app/screens/data/data_screen.dart';
import 'package:safe_kitchen_app/state/app_state.dart';
import 'package:safe_kitchen_app/theme/neon_carbon_theme.dart';

import 'helpers/fake_kitchen_source.dart';

void main() {
  setUpAll(() => GoogleFonts.config.allowRuntimeFetching = false);

  testWidgets('DataScreen hiển thị tiêu đề + nhãn cảm biến', (tester) async {
    final fake = FakeKitchenSource();
    final state = AppState(fake)..start();

    await tester.pumpWidget(
      ChangeNotifierProvider<AppState>.value(
        value: state,
        child: MaterialApp(
          theme: NeonCarbonTheme.dark,
          home: const Scaffold(body: DataScreen()),
        ),
      ),
    );

    fake.emitSettings(const Settings());
    fake.emitSensors(const SensorData(temp: 30, hum: 60, gas: 100, smoke: 90));
    await tester.pump();
    await tester.pump();

    expect(find.text('N&Đ'), findsOneWidget);
    expect(find.text('NHIỆT ĐỘ'), findsOneWidget);
    expect(find.text('KHÍ GAS'), findsOneWidget);

    state.dispose();
  });
}
