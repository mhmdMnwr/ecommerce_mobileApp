import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../theme/app_colors.dart';
import '../utils/icons_helper.dart';
import 'package:ecommerce_app/l10n/app_localizations.dart';

/// Main app scaffold with a persistent bottom navigation bar.
///
/// Wraps the [StatefulNavigationShell] from GoRouter to maintain
/// state across tabs.
class AppShell extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const AppShell({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    final currentIndex = navigationShell.currentIndex;

    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(color: AppColors.fieldBorder, width: 0.5),
          ),
        ),
        child: NavigationBar(
          selectedIndex: currentIndex,
          onDestinationSelected: (index) => navigationShell.goBranch(
            index,
            initialLocation: index == currentIndex,
          ),
          backgroundColor: AppColors.background,
          surfaceTintColor: Colors.transparent,
          indicatorColor: Colors.transparent,
          height: 64.h,
          labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
          destinations: [
            _buildDestination(
              asset: IconsHelper.home,
              label: AppLocalizations.of(context)!.home,
              isSelected: currentIndex == 0,
            ),
            _buildDestination(
              asset: IconsHelper.search,
              label: AppLocalizations.of(context)!.search,
              isSelected: currentIndex == 1,
            ),
            _buildDestination(
              asset: IconsHelper.cart,
              label: AppLocalizations.of(context)!.cart,
              isSelected: currentIndex == 2,
            ),
            _buildDestination(
              asset: IconsHelper.categories,
              label: AppLocalizations.of(context)!.categories,
              isSelected: currentIndex == 3,
            ),
            _buildDestination(
              asset: IconsHelper.user,
              label: AppLocalizations.of(context)!.profile,
              isSelected: currentIndex == 4,
            ),
          ],
        ),
      ),
    );
  }

  /// Builds a nav destination with opacity + dot indicator.
  NavigationDestination _buildDestination({
    required String asset,
    required String label,
    required bool isSelected,
  }) {
    return NavigationDestination(
      icon: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            asset,
            width: 24.r,
            height: 24.r,
            color: isSelected ? AppColors.primary : Colors.black,
          ),
          SizedBox(height: 4.h),
          Container(
            width: 5.r,
            height: 5.r,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSelected ? AppColors.primary : Colors.transparent,
            ),
          ),
        ],
      ),
      label: label,
    );
  }
}
