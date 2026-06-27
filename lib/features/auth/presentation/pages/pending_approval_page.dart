import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../core/locale/locale_cubit.dart';
import '../../../../core/routing/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../profile/presentation/widgets/language_dialog.dart';
import '../../../notifications/presentation/cubit/notification_cubit.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';
import 'package:ecommerce_app/l10n/app_localizations.dart';

/// Locked screen shown when a customer's account is inactive.
/// No logout, no back — the user stays here until admin activates them.
/// Only a refresh button to re-check their status.
class PendingApprovalPage extends StatelessWidget {
  const PendingApprovalPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return PopScope(
      // Block the system back button — user can't leave this screen
      canPop: false,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: BlocListener<AuthCubit, AuthState>(
          listener: (context, state) {
            // Only navigate away when admin has activated the account
            if (state is AuthAuthenticated) {
              sl<NotificationCubit>().startPolling();
              context.go(AppRoutes.home);
            } else if (state is AuthUnauthenticated) {
              context.go(AppRoutes.login);
            }
          },
          child: SafeArea(
            child: Stack(
              children: [
                Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40.w),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // ── Icon ──
                        Container(
                          width: 120.r,
                          height: 120.r,
                          decoration: BoxDecoration(
                            color: AppColors.primary.withAlpha(15),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.hourglass_top_rounded,
                            size: 56.r,
                            color: AppColors.primary,
                          ),
                        ),
                        SizedBox(height: 32.h),

                        // ── Title ──
                        Text(
                          l10n.pendingApprovalTitle,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 24.sp,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary,
                            letterSpacing: -0.5,
                          ),
                        ),
                        SizedBox(height: 16.h),

                        // ── Subtitle ──
                        Text(
                          l10n.pendingApprovalMessage,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: AppColors.textSecondary,
                            height: 1.5,
                          ),
                        ),
                        SizedBox(height: 40.h),

                        // ── Refresh / Check Status button ──
                        SizedBox(
                          width: double.infinity,
                          height: 52.h,
                          child: BlocBuilder<AuthCubit, AuthState>(
                            builder: (context, state) {
                              return ElevatedButton.icon(
                                onPressed: state is AuthLoading
                                    ? null
                                    : () => context.read<AuthCubit>().checkAuthStatus(),
                                icon: state is AuthLoading
                                    ? SizedBox(
                                        width: 18.r,
                                        height: 18.r,
                                        child: const CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.white,
                                        ),
                                      )
                                    : Icon(Icons.refresh_rounded, size: 20.r),
                                label: Text(
                                  l10n.checkStatus,
                                  style: TextStyle(
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14.r),
                                  ),
                                  elevation: 0,
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // ── Language toggle ──
                Positioned(
                  top: 16.h,
                  right: 16.w,
                  child: IconButton(
                    icon: Icon(Icons.language, color: AppColors.textPrimary, size: 28.r),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (ctx) => LanguageDialog(localeCubit: sl<LocaleCubit>()),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
