import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../auth/data/models/user_model.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../auth/presentation/cubit/auth_state.dart';
import '../widgets/password_reset_dialog.dart';

/// Shows user's personal info and allows editing.
class ProfileInformationPage extends StatelessWidget {
  const ProfileInformationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Profile Information',
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
                'Not logged in',
                style: TextStyle(
                    fontSize: 15.sp, color: AppColors.textSecondary),
              ),
            );
          }

          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              children: [
                SizedBox(height: 16.h),

                // ── Avatar ──────────────────────
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
                  child: Icon(
                    Icons.sentiment_satisfied_alt_outlined,
                    size: 38.r,
                    color: AppColors.primary,
                  ),
                ),
                SizedBox(height: 28.h),

                // ── Personal Information card ───
                _InfoCard(
                  title: 'Personal Information',
                  action: AppButton(
                    text: 'Edit',
                    onPressed: () => _showEditProfile(context, user),
                  ),
                  children: [
                    _InfoRow(label: 'Name', value: user.username),
                    _InfoRow(label: 'Phone', value: user.phone),
                    _InfoRow(
                        label: 'Address',
                        value: user.address.isNotEmpty
                            ? user.address
                            : 'Not set'),
                  ],
                ),
                SizedBox(height: 20.h),

                // ── Privacy card ────────────────
                _InfoCard(
                  title: 'Privacy',
                  action: AppButton(
                    text: 'Edit Password',
                    onPressed: () => showDialog(
                      context: context,
                      builder: (_) => PasswordResetDialog(
                        authCubit: context.read<AuthCubit>(),
                      ),
                    ),
                  ),
                  children: [
                    _InfoRow(label: 'Password', value: '••••••••••••'),
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

  void _showEditProfile(BuildContext context, UserModel user) {
    final nameCtrl = TextEditingController(text: user.username);
    final phoneCtrl = TextEditingController(text: user.phone);
    final addressCtrl = TextEditingController(text: user.address);
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: AppColors.background,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r)),
        insetPadding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Padding(
          padding: EdgeInsets.all(24.r),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Edit Profile',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(ctx),
                      child: Icon(Icons.close, size: 22.r,
                          color: AppColors.textSecondary),
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
                AppTextField(
                  controller: nameCtrl,
                  hintText: 'Name',
                  validator: Validators.username,
                ),
                SizedBox(height: 12.h),
                AppTextField(
                  controller: phoneCtrl,
                  hintText: 'Phone',
                  keyboardType: TextInputType.phone,
                  validator: Validators.phone,
                ),
                SizedBox(height: 12.h),
                AppTextField(
                  controller: addressCtrl,
                  hintText: 'Address',
                ),
                SizedBox(height: 20.h),
                AppButton(
                  text: 'Save',
                  onPressed: () {
                    if (!formKey.currentState!.validate()) return;
                    context.read<AuthCubit>().updateProfile(
                          username: nameCtrl.text.trim(),
                          address: addressCtrl.text.trim(),
                          phone: phoneCtrl.text.trim(),
                        );
                    Navigator.pop(ctx);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Info card with border ──────────────────────────

class _InfoCard extends StatelessWidget {
  final String title;
  final List<Widget> children;
  final Widget action;

  const _InfoCard({
    required this.title,
    required this.children,
    required this.action,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.fieldBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(height: 12.h),
          ...children,
          SizedBox(height: 16.h),
          action,
        ],
      ),
    );
  }
}

// ── Info row (label + value) ──────────────────────

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80.w,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14.sp,
                color: AppColors.textBody,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
