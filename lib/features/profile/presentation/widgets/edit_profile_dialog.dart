import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../auth/data/models/user_model.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import 'package:ecommerce_app/l10n/app_localizations.dart';

/// Dialog to edit username, phone and address.
class EditProfileDialog extends StatelessWidget {
  final UserModel user;

  EditProfileDialog({super.key, required this.user})
      : _nameCtrl = TextEditingController(text: user.username),
        _phoneCtrl = TextEditingController(text: user.phone),
        _addressCtrl = TextEditingController(text: user.address);

  final TextEditingController _nameCtrl;
  final TextEditingController _phoneCtrl;
  final TextEditingController _addressCtrl;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Dialog(
      backgroundColor: AppColors.background,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      insetPadding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Padding(
        padding: EdgeInsets.all(24.r),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    l10n.editProfile,
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Icon(
                      Icons.close,
                      size: 22.r,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.h),
              AppTextField(
                controller: _nameCtrl,
                hintText: l10n.name,
                validator: (v) => Validators.username(context, v),
              ),
              SizedBox(height: 12.h),
              AppTextField(
                controller: _phoneCtrl,
                hintText: l10n.phone,
                keyboardType: TextInputType.phone,
                validator: (v) => Validators.phone(context, v),
              ),
              SizedBox(height: 12.h),
              AppTextField(
                controller: _addressCtrl,
                hintText: l10n.address,
              ),
              SizedBox(height: 20.h),
              AppButton(
                text: l10n.save,
                onPressed: () {
                  if (!_formKey.currentState!.validate()) return;
                  context.read<AuthCubit>().updateProfile(
                        username: _nameCtrl.text.trim(),
                        address: _addressCtrl.text.trim(),
                        phone: _phoneCtrl.text.trim(),
                      );
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
