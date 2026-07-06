import 'package:flutter/material.dart';

import '../screens/control/control_screen.dart';
import '../screens/data/data_screen.dart';
import '../screens/user/user_screen.dart';
import '../services/update_service.dart';
import '../theme/neon_carbon_colors.dart';
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

  static const _screens = [DataScreen(), ControlScreen(), UserScreen()];

  @override
  void initState() {
    super.initState();
    // Kiểm tra cập nhật 1 lần khi mở app (sau khi có Navigator).
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkForUpdate());
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
