import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_colors.dart';

/// Reusable settings / profile menu item row.
class ProfileMenuItem extends StatelessWidget {
  final String? pngAsset;
  final IconData? icon;
  final String title;
  final VoidCallback onTap;
  final Color? titleColor;
  final Color? iconColor;
  final bool showArrow;

  const ProfileMenuItem({
    super.key,
    this.pngAsset,
    this.icon,
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
        padding: EdgeInsets.symmetric(vertical: 18.h),
        child: Row(
          children: [
            if (pngAsset != null)
              Image.asset(pngAsset!, width: 28.r, height: 28.r)
            else
              Icon(
                icon ?? Icons.circle,
                size: 28.r,
                color: iconColor ?? AppColors.textMuted,
              ),
            SizedBox(width: 18.w),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16.sp,
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
