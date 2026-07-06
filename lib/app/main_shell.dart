import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/control/control_screen.dart';
import '../screens/data/data_screen.dart';
import '../screens/user/user_screen.dart';
import '../models/controls.dart';
import '../services/update_service.dart';
import '../state/app_state.dart';
import '../theme/neon_carbon_colors.dart';
import '../widgets/update_dialog.dart';

/// Khung chính: 3 tab Data / Control / User qua NavigationBar dưới đáy.
class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> with WidgetsBindingObserver {
  int _index = 0;
  final _updateService = UpdateService();
  AppState? _appState; // ref để dùng trong lifecycle callback

  static const _screens = [DataScreen(), ControlScreen(), UserScreen()];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _appState = context.read<AppState>();
      _checkForUpdate();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Rời/thoát app: nếu đang Thủ công → tự chuyển Tự động để firmware tự lo an
    // toàn (đóng van / bật quạt / bơm khi nguy hiểm) lúc không ai theo dõi app.
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      final s = _appState;
      if (s != null && s.controls.isManual) {
        s.setMode(DeviceMode.auto);
      }
    }
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
