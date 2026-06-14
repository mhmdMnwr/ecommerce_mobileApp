import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theme/app_colors.dart';
import '../utils/icons_helper.dart';

/// Shows a non-dismissible loading popup with the timer icon and a message.
///
/// Usage:
/// ```dart
/// AppLoadingDialog.show(context, message: 'Please wait...');
/// // ... do async work ...
/// AppLoadingDialog.hide(context);
/// ```
class AppLoadingDialog {
  AppLoadingDialog._();

  /// Shows the loading overlay.
  static void show(BuildContext context, {String? message}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black26,
      builder: (_) => PopScope(
        canPop: false,
        child: Center(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 60.w),
            padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 28.h),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(16.r),
              boxShadow: const [
                BoxShadow(
                  color: AppColors.shadow,
                  blurRadius: 20,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  IconsHelper.timer,
                  width: 48.r,
                  height: 48.r,
                ),
                if (message != null) ...[
                  SizedBox(height: 18.h),
                  Text(
                    message,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textBody,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Hides the loading overlay.
  static void hide(BuildContext context) {
    if (Navigator.of(context, rootNavigator: true).canPop()) {
      Navigator.of(context, rootNavigator: true).pop();
    }
  }
}
