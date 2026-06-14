import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import 'package:ecommerce_app/l10n/app_localizations.dart';

/// Dialog for changing the user's password.
///
/// Shows old password, new password, and confirmation fields.
class PasswordResetDialog extends StatefulWidget {
  final AuthCubit authCubit;

  const PasswordResetDialog({super.key, required this.authCubit});

  @override
  State<PasswordResetDialog> createState() => _PasswordResetDialogState();
}

class _PasswordResetDialogState extends State<PasswordResetDialog> {
  final _formKey = GlobalKey<FormState>();
  final _oldCtrl = TextEditingController();
  final _newCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();

  @override
  void dispose() {
    _oldCtrl.dispose();
    _newCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    if (_newCtrl.text != _confirmCtrl.text) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(
          content: Text(AppLocalizations.of(context)!.passwordsDoNotMatch),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
        ));
      return;
    }

    // TODO: Call password change endpoint when available
    Navigator.pop(context);
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        content: Text(AppLocalizations.of(context)!.passwordUpdated),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
      ));
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.background,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      insetPadding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Padding(
        padding: EdgeInsets.all(24.r),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Header ──────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppLocalizations.of(context)!.passwordReset,
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Icon(Icons.close, size: 22.r,
                        color: AppColors.textSecondary),
                  ),
                ],
              ),
              SizedBox(height: 20.h),

              // ── Fields ──────────────────
              AppTextField(
                controller: _oldCtrl,
                hintText: AppLocalizations.of(context)!.oldPassword,
                obscureText: true,
                validator: (v) =>
                    (v == null || v.isEmpty) ? AppLocalizations.of(context)!.requiredField : null,
              ),
              SizedBox(height: 12.h),
              AppTextField(
                controller: _newCtrl,
                hintText: AppLocalizations.of(context)!.newPassword,
                obscureText: true,
                validator: (v) {
                  if (v == null || v.isEmpty) return AppLocalizations.of(context)!.requiredField;
                  if (v.length < 6) return AppLocalizations.of(context)!.atLeast6Chars;
                  return null;
                },
              ),
              SizedBox(height: 12.h),
              AppTextField(
                controller: _confirmCtrl,
                hintText: AppLocalizations.of(context)!.newPasswordConfirmation,
                obscureText: true,
                validator: (v) =>
                    (v == null || v.isEmpty) ? AppLocalizations.of(context)!.requiredField : null,
              ),
              SizedBox(height: 20.h),

              // ── Submit ──────────────────
              AppButton(text: AppLocalizations.of(context)!.edit, onPressed: _submit),
            ],
          ),
        ),
      ),
    );
  }
}
