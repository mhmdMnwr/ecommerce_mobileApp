import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/utils/icons_helper.dart';
import 'package:ecommerce_app/l10n/app_localizations.dart';

/// Floating chip that shows "Detecting location…" with a spinner.
class MapLocatingChip extends StatelessWidget {
  const MapLocatingChip({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(24.r),
          boxShadow: const [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 10,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 16.r,
              height: 16.r,
              child: Image.asset(
                IconsHelper.timer,
                color: AppColors.primary,
              ),
            ),
            SizedBox(width: 10.w),
            Text(
              AppLocalizations.of(context)!.detectingLocation,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Floating chip that says "Tap on the map to select your location".
class MapInstructionChip extends StatelessWidget {
  const MapInstructionChip({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(24.r),
          boxShadow: const [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 10,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Text(
          AppLocalizations.of(context)!.tapMapToSelect,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: AppColors.textMuted,
          ),
        ),
      ),
    );
  }
}

/// Bottom card that shows the selected address and a confirm button.
class MapAddressCard extends StatelessWidget {
  final bool isLoading;
  final String? address;
  final VoidCallback? onConfirm;

  const MapAddressCard({
    super.key,
    required this.isLoading,
    this.address,
    this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadowMedium,
            blurRadius: 20,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.location_on,
                  color: AppColors.markerRed, size: 20.r),
              SizedBox(width: 8.w),
              Text(
                l10n.selectedLocation,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15.sp,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          if (isLoading)
            Center(
              child: SizedBox(
                width: 20.r,
                height: 20.r,
                child: Image.asset(IconsHelper.timer),
              ),
            )
          else
            Text(
              address ?? '',
              style: TextStyle(
                fontSize: 13.sp,
                color: AppColors.textBody,
                height: 1.4,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          SizedBox(height: 16.h),
          AppButton(
            text: l10n.confirmLocation,
            height: 48.h,
            onPressed: onConfirm,
          ),
        ],
      ),
    );
  }
}
