import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../theme/app_colors.dart';
import '../utils/icons_helper.dart';

class AppLoadingIndicator extends StatelessWidget {
  final String? message;
  final double? size;

  const AppLoadingIndicator({super.key, this.message, this.size});

  @override
  Widget build(BuildContext context) {
    return Center(
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
              width: size ?? 48.r,
              height: size ?? 48.r,
            ),
            if (message != null) ...[
              SizedBox(height: 18.h),
              Text(
                message!,
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
    );
  }
}
