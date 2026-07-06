import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:safe_kitchen_app/models/controls.dart';
import 'package:safe_kitchen_app/screens/control/control_screen.dart';
import 'package:safe_kitchen_app/state/app_state.dart';
import 'package:safe_kitchen_app/theme/neon_carbon_theme.dart';

import 'helpers/fake_kitchen_source.dart';

void main() {
  setUpAll(() => GoogleFonts.config.allowRuntimeFetching = false);

  Widget wrap(AppState state) => ChangeNotifierProvider<AppState>.value(
        value: state,
        child: MaterialApp(
          theme: NeonCarbonTheme.dark,
          home: const Scaffold(body: ControlScreen()),
        ),
      );

  testWidgets('Auto khoá switch, Manual mở switch', (tester) async {
    final fake = FakeKitchenSource();
    final state = AppState(fake)..start();
    await tester.pumpWidget(wrap(state));

    fake.emitControls(const Controls(mode: DeviceMode.auto));
    await tester.pump();
    final autoSwitches = tester.widgetList<Switch>(find.byType(Switch));
    expect(autoSwitches.isNotEmpty, true);
    expect(autoSwitches.every((s) => s.onChanged == null), true);

    fake.emitControls(const Controls(mode: DeviceMode.manual));
    await tester.pump();
    final manualSwitches = tester.widgetList<Switch>(find.byType(Switch));
    expect(manualSwitches.any((s) => s.onChanged != null), true);

    state.dispose();
  });

  testWidgets('Manual: bật quạt hút ghi xuống source', (tester) async {
    final fake = FakeKitchenSource();
    final state = AppState(fake)..start();
    await tester.pumpWidget(wrap(state));

    fake.emitControls(const Controls(mode: DeviceMode.manual));
    await tester.pump();

    // Thứ tự thiết bị: valve(0), exhaustFan(1), coolFan(2), pump(3)
    await tester.tap(find.byType(Switch).at(1));
    await tester.pump();
    expect(fake.deviceCalls, contains('exhaustFan=true'));

    state.dispose();
  });
}
