import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/app_text_field.dart';
import 'package:ecommerce_app/l10n/app_localizations.dart';

/// The core form fields for registration: username, phone, password, address.
class RegisterFormFields extends StatelessWidget {
  final TextEditingController usernameCtrl;
  final TextEditingController phoneCtrl;
  final TextEditingController passwordCtrl;
  final TextEditingController addressCtrl;
  final bool obscure;
  final VoidCallback onToggleObscure;

  const RegisterFormFields({
    super.key,
    required this.usernameCtrl,
    required this.phoneCtrl,
    required this.passwordCtrl,
    required this.addressCtrl,
    required this.obscure,
    required this.onToggleObscure,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      children: [
        AppTextField(
          controller: usernameCtrl,
          hintText: l10n.name,
          validator: (v) => Validators.username(context, v),
          textInputAction: TextInputAction.next,
        ),
        SizedBox(height: 14.h),
        AppTextField(
          controller: phoneCtrl,
          hintText: l10n.phoneNumber,
          keyboardType: TextInputType.phone,
          validator: (v) => Validators.phone(context, v),
          textInputAction: TextInputAction.next,
        ),
        SizedBox(height: 14.h),
        AppTextField(
          controller: passwordCtrl,
          hintText: l10n.password,
          obscureText: obscure,
          validator: (v) => Validators.password(context, v),
          textInputAction: TextInputAction.next,
          suffixIcon: GestureDetector(
            onTap: onToggleObscure,
            child: Icon(
              obscure
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              color: AppColors.textHint,
              size: 20.r,
            ),
          ),
        ),
        SizedBox(height: 14.h),
        AppTextField(
          controller: addressCtrl,
          hintText: l10n.deliveryAddress,
          textInputAction: TextInputAction.done,
        ),
      ],
    );
  }
}
