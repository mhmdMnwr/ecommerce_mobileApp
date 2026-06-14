import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../core/locale/locale_cubit.dart';
import '../../../../core/routing/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/theme_cubit.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../auth/presentation/cubit/auth_state.dart';
import '../widgets/language_dialog.dart';
import '../widgets/theme_dialog.dart';

/// Main profile screen — shows user info and menu items.
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Profile',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.background,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
      ),
      body: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          final user = state is AuthAuthenticated ? state.user : null;

          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              children: [
                SizedBox(height: 16.h),

                // ── User info header ────────────────
                Row(
                  children: [
                    Container(
                      width: 56.r,
                      height: 56.r,
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.fieldBorder,
                          width: 1.5,
                        ),
                      ),
                      child: Icon(
                        Icons.sentiment_satisfied_alt_outlined,
                        size: 30.r,
                        color: AppColors.primary,
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user?.username ?? 'Guest',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            user?.phone ?? '',
                            style: TextStyle(
                              fontSize: 13.sp,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 32.h),

                // ── Menu items ──────────────────────
                _MenuItem(
                  icon: Icons.person_outline,
                  title: 'Profile information',
                  onTap: () => context.push(AppRoutes.profileInfo),
                ),
                _MenuItem(
                  icon: Icons.notifications_none_outlined,
                  title: 'Notification',
                  onTap: () => _comingSoon(context),
                ),
                _MenuItem(
                  icon: Icons.receipt_long_outlined,
                  title: 'Orders history',
                  onTap: () => _comingSoon(context),
                ),
                _MenuItem(
                  icon: Icons.language_outlined,
                  title: 'Language',
                  onTap: () => showDialog(
                    context: context,
                    builder: (_) => LanguageDialog(
                      localeCubit: sl<LocaleCubit>(),
                    ),
                  ),
                ),
                _MenuItem(
                  icon: Icons.dark_mode_outlined,
                  title: 'Theme',
                  onTap: () => showDialog(
                    context: context,
                    builder: (_) => ThemeDialog(
                      themeCubit: sl<ThemeCubit>(),
                    ),
                  ),
                ),
                _MenuItem(
                  icon: Icons.phone_outlined,
                  title: 'Contact us',
                  onTap: () => _comingSoon(context),
                ),

                SizedBox(height: 32.h),

                // ── Logout ──────────────────────────
                _MenuItem(
                  icon: Icons.logout_rounded,
                  title: 'Log out',
                  titleColor: AppColors.error,
                  iconColor: AppColors.error,
                  showArrow: false,
                  onTap: () {
                    context.read<AuthCubit>().logout();
                    context.go(AppRoutes.login);
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _comingSoon(BuildContext context) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: const Text('Coming soon'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppColors.primary,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
          duration: const Duration(seconds: 1),
        ),
      );
  }
}

// ── Reusable menu item row ─────────────────────────

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final Color? titleColor;
  final Color? iconColor;
  final bool showArrow;

  const _MenuItem({
    required this.icon,
    required this.title,
    required this.onTap,
    this.titleColor,
    this.iconColor,
    this.showArrow = true,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 16.h),
        child: Row(
          children: [
            Icon(
              icon,
              size: 24.r,
              color: iconColor ?? AppColors.textMuted,
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w500,
                  color: titleColor ?? AppColors.textPrimary,
                ),
              ),
            ),
            if (showArrow)
              Icon(
                Icons.arrow_forward_ios,
                size: 16.r,
                color: AppColors.textSecondary,
              ),
          ],
        ),
      ),
    );
  }
}
