import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/control/control_screen.dart';
import '../screens/data/data_screen.dart';
import '../screens/user/user_screen.dart';
import '../services/update_service.dart';
import '../state/app_state.dart';
import '../theme/neon_carbon_colors.dart';
import '../widgets/danger_alert_dialog.dart';
import '../widgets/update_dialog.dart';

/// Khung chính: 3 tab Data / Control / User qua NavigationBar dưới đáy.
class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 0;
  final _updateService = UpdateService();

  AppState? _appState; // giữ ref để gỡ listener khi dispose
  bool _dangerShown = false; // popup nguy hiểm đang mở?

  static const _screens = [DataScreen(), ControlScreen(), UserScreen()];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkForUpdate();
      // Lắng nghe nguy hiểm → tự bật popup cảnh báo.
      _appState = context.read<AppState>()..addListener(_onDanger);
      _onDanger(); // kiểm tra ngay (phòng khi mở app lúc đang nguy hiểm)
    });
  }

  @override
  void dispose() {
    _appState?.removeListener(_onDanger);
    super.dispose();
  }

  /// Có nguy hiểm & popup chưa mở → bật popup sticky (tự đóng khi hết nguy hiểm).
  void _onDanger() {
    if (!mounted || _dangerShown) return;
    if (_appState?.isDanger != true) return;
    _dangerShown = true;
    DangerAlertDialog.show(context).then((_) => _dangerShown = false);
  }

  Future<void> _checkForUpdate() async {
    try {
      final info = await _updateService.check();
      if (info != null && mounted) {
        await UpdateDialog.show(context, info, _updateService);
      }
    } catch (_) {
      // Im lặng khi khởi động (offline/lỗi mạng) — không quấy user.
      // Nút "Kiểm tra cập nhật" ở tab Cài đặt sẽ hiện lỗi rõ nếu cần.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: IndexedStack(index: _index, children: _screens)),
      bottomNavigationBar: DecoratedBox(
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: context.nc.carbonLine)),
        ),
        child: NavigationBar(
          backgroundColor: context.nc.carbonPanel,
          indicatorColor: context.nc.cyanDim,
          selectedIndex: _index,
          onDestinationSelected: (i) => setState(() => _index = i),
          destinations: [
            NavigationDestination(
              icon: const Icon(Icons.sensors_outlined),
              selectedIcon: Icon(Icons.sensors, color: context.nc.cyan),
              label: 'DATA',
            ),
            NavigationDestination(
              icon: const Icon(Icons.tune_outlined),
              selectedIcon: Icon(Icons.tune, color: context.nc.cyan),
              label: 'CONTROL',
            ),
            NavigationDestination(
              icon: const Icon(Icons.settings_outlined),
              selectedIcon: Icon(Icons.settings, color: context.nc.cyan),
              label: 'USER',
            ),
          ],
        ),
      ),
    );
  }
}
