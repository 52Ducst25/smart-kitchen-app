import 'package:flutter_test/flutter_test.dart';
import 'package:safe_kitchen_app/models/controls.dart';
import 'package:safe_kitchen_app/models/sensor_data.dart';
import 'package:safe_kitchen_app/models/settings.dart';
import 'package:safe_kitchen_app/state/app_state.dart';

import 'helpers/fake_kitchen_source.dart';

Future<void> _tick() => Future<void>.delayed(const Duration(milliseconds: 10));

void main() {
  test('isDanger + activeAlerts phản ánh vượt ngưỡng', () async {
    final fake = FakeKitchenSource();
    final state = AppState(fake)..start();

    fake.emitSettings(const Settings(gasTh: 300, smokeTh: 200, tempTh: 45));
    fake.emitSensors(const SensorData(temp: 30, gas: 100, smoke: 100));
    await _tick();
    expect(state.isDanger, false);
    expect(state.activeAlerts, isEmpty);

    fake.emitSensors(const SensorData(temp: 30, gas: 400, smoke: 100));
    await _tick();
    expect(state.isDanger, true);
    expect(state.activeAlerts.length, 1);

    fake.emitSensors(
      const SensorData(temp: 50, gas: 400, smoke: 300, flame: true),
    );
    await _tick();
    expect(state.isDanger, true);
    expect(state.activeAlerts.length, 4);

    state.dispose();
  });

  test('history ring buffer giới hạn 30 điểm', () async {
    final fake = FakeKitchenSource();
    final state = AppState(fake)..start();
    for (var i = 0; i < 40; i++) {
      fake.emitSensors(SensorData(temp: i.toDouble()));
    }
    await _tick();
    expect(state.history.length, 30);
    state.dispose();
  });

  test('điều khiển đi qua source', () async {
    final fake = FakeKitchenSource();
    final state = AppState(fake)..start();
    await state.setDevice('valve', true);
    await state.setMode(DeviceMode.manual);
    await state.updateSettings(const Settings(gasTh: 111));
    expect(fake.deviceCalls, contains('valve=true'));
    expect(fake.modeCalls, contains(DeviceMode.manual));
    expect(fake.settingsWrites.single.gasTh, 111);
    state.dispose();
  });
}
