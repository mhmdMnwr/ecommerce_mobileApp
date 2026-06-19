import 'package:ecommerce_app/core/utils/icons_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../auth/presentation/cubit/auth_state.dart';
import '../../../auth/presentation/pages/map_picker_page.dart';
import '../widgets/edit_profile_dialog.dart';
import '../widgets/info_card.dart';
import '../widgets/password_reset_dialog.dart';
import 'package:ecommerce_app/l10n/app_localizations.dart';

/// Shows user's personal info and allows editing.
class ProfileInformationPage extends StatelessWidget {
  const ProfileInformationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          l10n.profileInformation,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.background,
        surfaceTintColor: Colors.transparent,
        foregroundColor: AppColors.primary,
        elevation: 0,
      ),
      body: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          final user = state is AuthAuthenticated ? state.user : null;
          if (user == null) {
            return Center(
              child: Text(
                l10n.notLoggedIn,
                style: TextStyle(
                  fontSize: 15.sp,
                  color: AppColors.textSecondary,
                ),
              ),
            );
          }

          final hasLocation = user.latitude != null && user.longitude != null;

          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              children: [
                SizedBox(height: 16.h),

                // Avatar
                Container(
                  width: 72.r,
                  height: 72.r,
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.fieldBorder,
                      width: 1.5,
                    ),
                  ),
                  child: Image.asset(IconsHelper.userAccount),
                ),
                SizedBox(height: 28.h),

                // Personal info card
                InfoCard(
                  title: l10n.personalInformation,
                  action: AppButton(
                    text: l10n.edit,
                    onPressed: () => showDialog(
                      context: context,
                      builder: (_) => EditProfileDialog(user: user),
                    ),
                  ),
                  children: [
                    InfoRow(label: l10n.name, value: user.username),
                    InfoRow(label: l10n.phone, value: user.phone),
                    InfoRow(
                      label: l10n.address,
                      value: user.address.isNotEmpty
                          ? user.address
                          : l10n.notSet,
                    ),
                  ],
                ),
                SizedBox(height: 20.h),

                // Location card
                InfoCard(
                  title: l10n.location,
                  action: AppButton(
                    text: l10n.changeLocation,
                    onPressed: () => _openMapPicker(context),
                  ),
                  children: [
                    LocationRow(
                      hasLocation: hasLocation,
                      label: hasLocation
                          ? l10n.locationSet
                          : l10n.locationNotSet,
                    ),
                  ],
                ),
                SizedBox(height: 20.h),

                // Privacy card
                InfoCard(
                  title: l10n.privacy,
                  action: AppButton(
                    text: l10n.editPassword,
                    onPressed: () => showDialog(
                      context: context,
                      builder: (_) => PasswordResetDialog(
                        authCubit: context.read<AuthCubit>(),
                      ),
                    ),
                  ),
                  children: [
                    InfoRow(label: l10n.password, value: '••••••••••••'),
                  ],
                ),
                SizedBox(height: 32.h),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _openMapPicker(BuildContext context) async {
    final result = await Navigator.of(context).push<MapPickerResult>(
      MaterialPageRoute(builder: (_) => const MapPickerPage()),
    );
    if (result != null && context.mounted) {
      context.read<AuthCubit>().updateProfile(
        address: result.address,
        latitude: result.latitude,
        longitude: result.longitude,
      );
    }
  }
}
