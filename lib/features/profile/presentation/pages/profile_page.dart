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
import 'package:ecommerce_app/l10n/app_localizations.dart';
import '../../../../core/utils/icons_helper.dart';
import '../widgets/profile_menu_item.dart';

/// Main profile screen — shows user info and menu items.
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.profile,
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
                      width: 60.r,
                      height: 60.r,
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.fieldBorder,
                          width: 1.5,
                        ),
                      ),
                      child: Image.asset(
                        IconsHelper.userAccount,
                        height: 60.r,
                        width: 60.r,
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user?.username ??
                                AppLocalizations.of(context)!.guest,
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
                SizedBox(height: 36.h),

                // ── Menu items ──────────────────────
                ProfileMenuItem(
                  pngAsset: IconsHelper.userAccount,
                  title: AppLocalizations.of(context)!.profileInformation,
                  onTap: () => context.push(AppRoutes.profileInfo),
                ),
                ProfileMenuItem(
                  pngAsset: IconsHelper.notification,
                  title: AppLocalizations.of(context)!.notification,
                  onTap: () => _comingSoon(context),
                ),
                ProfileMenuItem(
                  pngAsset: IconsHelper.orderHistory,
                  title: AppLocalizations.of(context)!.ordersHistory,
                  onTap: () => _comingSoon(context),
                ),
                ProfileMenuItem(
                  pngAsset: IconsHelper.language,
                  title: AppLocalizations.of(context)!.language,
                  onTap: () => showDialog(
                    context: context,
                    builder: (_) =>
                        LanguageDialog(localeCubit: sl<LocaleCubit>()),
                  ),
                ),
                ProfileMenuItem(
                  pngAsset: IconsHelper.theme,
                  title: AppLocalizations.of(context)!.theme,
                  onTap: () => showDialog(
                    context: context,
                    builder: (_) => ThemeDialog(themeCubit: sl<ThemeCubit>()),
                  ),
                ),
                ProfileMenuItem(
                  pngAsset: IconsHelper.phone,
                  title: AppLocalizations.of(context)!.contactUs,
                  onTap: () => _comingSoon(context),
                ),

                SizedBox(height: 36.h),

                // ── Logout ──────────────────────────
                ProfileMenuItem(
                  icon: Icons.logout_rounded,
                  title: AppLocalizations.of(context)!.logOut,
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
          content: Text(AppLocalizations.of(context)!.comingSoon),
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppColors.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.r),
          ),
          duration: const Duration(seconds: 1),
        ),
      );
  }
}
