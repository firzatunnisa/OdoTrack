import 'package:flutter/material.dart';
import 'dashboard/dashboard_page.dart';
import 'vehicle/vehicle_list_page.dart';
import 'dashboard/reminder_page.dart';
import 'profile/profile_page.dart';
import '../widgets/app_bottom_nav_bar.dart';

/// MainScreen provides a persistent shell scaffold with the 4 core tabs:
/// 0: Beranda (DashboardPage)
/// 1: Kendaraan (VehicleListPage)
/// 2: Pengingat (ReminderPage)
/// 3: Akun (ProfilePage)
///
/// The bottom navigation bar stays persistent across all tabs without flashing
/// or rebuilding unnecessarily.
class MainScreen extends StatefulWidget {
  final int initialIndex;
  const MainScreen({super.key, this.initialIndex = 0});

  /// Allows any child widget to switch tabs programmatically
  /// (e.g. from quick actions on Dashboard).
  static void switchTab(BuildContext context, int index) {
    final state = context.findAncestorStateOfType<MainScreenState>();
    if (state != null) {
      state.setIndex(index);
    }
  }

  @override
  State<MainScreen> createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  void setIndex(int index) {
    if (_currentIndex != index) {
      setState(() => _currentIndex = index);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _currentIndex == 0,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop && _currentIndex != 0) {
          setState(() => _currentIndex = 0);
        }
      },
      child: Scaffold(
        body: IndexedStack(
          index: _currentIndex,
          children: const [
            DashboardPage(isEmbedded: true),
            VehicleListPage(isEmbedded: true),
            ReminderPage(isEmbedded: true),
            ProfilePage(isEmbedded: true),
          ],
        ),
        bottomNavigationBar: AppBottomNavBar(
          currentIndex: _currentIndex,
          onTap: (index) => setIndex(index),
        ),
      ),
    );
  }
}
