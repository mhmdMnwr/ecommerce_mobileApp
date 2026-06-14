import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/icons_helper.dart';

/// Bordered card used to group profile info sections.
class InfoCard extends StatelessWidget {
  final String title;
  final List<Widget> children;
  final Widget action;

  const InfoCard({
    super.key,
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

/// A label + value row inside an [InfoCard].
class InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const InfoRow({super.key, required this.label, required this.value});

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

/// Location row with a map icon and check indicator.
class LocationRow extends StatelessWidget {
  final bool hasLocation;
  final String label;

  const LocationRow({
    super.key,
    required this.hasLocation,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        children: [
          Image.asset(
            IconsHelper.map,
            width: 24.r,
            height: 24.r,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: hasLocation
                    ? AppColors.success
                    : AppColors.textSecondary,
              ),
            ),
          ),
          if (hasLocation)
            Icon(
              Icons.check_circle_outline,
              size: 20.r,
              color: AppColors.success,
            ),
        ],
      ),
    );
  }
}
