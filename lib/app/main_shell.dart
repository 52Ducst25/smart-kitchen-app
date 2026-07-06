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
    final info = await _updateService.check();
    if (info != null && mounted) {
      await UpdateDialog.show(context, info, _updateService);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: IndexedStack(index: _index, children: _screens)),
      bottomNavigationBar: DecoratedBox(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: NcColors.carbonLine)),
        ),
        child: NavigationBar(
          backgroundColor: NcColors.carbonPanel,
          indicatorColor: NcColors.cyanDim,
          selectedIndex: _index,
          onDestinationSelected: (i) => setState(() => _index = i),
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.sensors_outlined),
              selectedIcon: Icon(Icons.sensors, color: NcColors.cyan),
              label: 'DATA',
            ),
            NavigationDestination(
              icon: Icon(Icons.tune_outlined),
              selectedIcon: Icon(Icons.tune, color: NcColors.cyan),
              label: 'CONTROL',
            ),
            NavigationDestination(
              icon: Icon(Icons.settings_outlined),
              selectedIcon: Icon(Icons.settings, color: NcColors.cyan),
              label: 'USER',
            ),
          ],
        ),
      ),
    );
  }
}
