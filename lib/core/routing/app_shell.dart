import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../theme/app_colors.dart';

/// Main app scaffold with a persistent bottom navigation bar.
///
/// Wraps the [StatefulNavigationShell] from GoRouter to maintain
/// state across tabs.
class AppShell extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const AppShell({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(color: AppColors.fieldBorder, width: 0.5),
          ),
        ),
        child: NavigationBar(
          selectedIndex: navigationShell.currentIndex,
          onDestinationSelected: (index) =>
              navigationShell.goBranch(index, initialLocation: index == navigationShell.currentIndex),
          backgroundColor: AppColors.background,
          surfaceTintColor: Colors.transparent,
          indicatorColor: Colors.transparent,
          height: 64.h,
          labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
          destinations: [
            NavigationDestination(
              icon: Icon(Icons.home_outlined, size: 24.r, color: AppColors.textSecondary),
              selectedIcon: Icon(Icons.home_rounded, size: 24.r, color: AppColors.primary),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(Icons.search_outlined, size: 24.r, color: AppColors.textSecondary),
              selectedIcon: Icon(Icons.search_rounded, size: 24.r, color: AppColors.primary),
              label: 'Search',
            ),
            NavigationDestination(
              icon: Icon(Icons.shopping_cart_outlined, size: 24.r, color: AppColors.textSecondary),
              selectedIcon: Icon(Icons.shopping_cart_rounded, size: 24.r, color: AppColors.primary),
              label: 'Cart',
            ),
            NavigationDestination(
              icon: Icon(Icons.grid_view_outlined, size: 24.r, color: AppColors.textSecondary),
              selectedIcon: Icon(Icons.grid_view_rounded, size: 24.r, color: AppColors.primary),
              label: 'Categories',
            ),
            NavigationDestination(
              icon: Icon(Icons.person_outline, size: 24.r, color: AppColors.textSecondary),
              selectedIcon: Icon(Icons.person_rounded, size: 24.r, color: AppColors.primary),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
