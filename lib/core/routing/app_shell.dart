import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../di/injection_container.dart';
import '../theme/app_colors.dart';
import '../utils/icons_helper.dart';
import '../../features/notifications/presentation/cubit/notification_cubit.dart';
import '../../features/notifications/presentation/cubit/notification_state.dart';
import 'package:ecommerce_app/l10n/app_localizations.dart';

class AppShell extends StatefulWidget {
  final StatefulNavigationShell navigationShell;
  const AppShell({super.key, required this.navigationShell});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  DateTime? _lastPressedAt;

  @override
  Widget build(BuildContext context) {
    final idx = widget.navigationShell.currentIndex;
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;

        // If go_router can pop deeper navigation, let it handle it.
        if (context.canPop()) {
          context.pop();
          return;
        }

        final now = DateTime.now();
        if (_lastPressedAt == null || now.difference(_lastPressedAt!) > const Duration(seconds: 2)) {
          _lastPressedAt = now;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context)!.pressBackAgainToExit),
              duration: const Duration(seconds: 2),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
              backgroundColor: AppColors.primaryLight,
            ),
          );
          return;
        }

        // Exit the app if pressed twice within 2 seconds
        SystemNavigator.pop();
      },
      child: Scaffold(
        body: widget.navigationShell,
        bottomNavigationBar: Container(
          decoration: const BoxDecoration(
            border: Border(top: BorderSide(color: AppColors.fieldBorder, width: 0.5)),
          ),
          child: NavigationBar(
            selectedIndex: idx,
            onDestinationSelected: (i) => widget.navigationShell.goBranch(i, initialLocation: i == idx),
            backgroundColor: AppColors.background,
            surfaceTintColor: Colors.transparent,
            indicatorColor: Colors.transparent,
            height: 64.h,
            labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
            destinations: [
              _dest(IconsHelper.home, AppLocalizations.of(context)!.home, idx == 0),
              _dest(IconsHelper.search, AppLocalizations.of(context)!.search, idx == 1),
              _dest(IconsHelper.cart, AppLocalizations.of(context)!.cart, idx == 2),
              _dest(IconsHelper.categories, AppLocalizations.of(context)!.categories, idx == 3),
              _profileDest(context, idx == 4),
            ],
          ),
        ),
      ),
    );
  }

  NavigationDestination _dest(String asset, String label, bool sel) {
    return NavigationDestination(
      icon: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(asset, width: 24.r, height: 24.r, color: sel ? AppColors.primary : Colors.black),
          SizedBox(height: 4.h),
          Container(width: 5.r, height: 5.r, decoration: BoxDecoration(shape: BoxShape.circle, color: sel ? AppColors.primary : Colors.transparent)),
        ],
      ),
      label: label,
    );
  }

  NavigationDestination _profileDest(BuildContext context, bool sel) {
    return NavigationDestination(
      icon: BlocBuilder<NotificationCubit, NotificationState>(
        bloc: sl<NotificationCubit>(),
        builder: (context, state) {
          final count = state is NotificationLoaded ? state.unreadCount : 0;
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Image.asset(IconsHelper.user, width: 24.r, height: 24.r, color: sel ? AppColors.primary : Colors.black),
                  if (count > 0)
                    Positioned(
                      right: -6, top: -4,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                        decoration: BoxDecoration(
                          color: AppColors.error,
                          borderRadius: BorderRadius.circular(10.r),
                          border: Border.all(color: AppColors.background, width: 1.5),
                        ),
                        constraints: BoxConstraints(minWidth: 16.r, minHeight: 14.r),
                        child: Text(
                          count > 99 ? '99+' : '$count',
                          style: TextStyle(color: Colors.white, fontSize: 9.sp, fontWeight: FontWeight.w700),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              ),
              SizedBox(height: 4.h),
              Container(width: 5.r, height: 5.r, decoration: BoxDecoration(shape: BoxShape.circle, color: sel ? AppColors.primary : Colors.transparent)),
            ],
          );
        },
      ),
      label: AppLocalizations.of(context)!.profile,
    );
  }
}
