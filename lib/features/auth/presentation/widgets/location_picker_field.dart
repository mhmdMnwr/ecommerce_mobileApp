import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/icons_helper.dart';
import 'package:ecommerce_app/l10n/app_localizations.dart';

/// Tappable row that shows either "Select location on map" or the
/// selected address with a clear button.
class LocationPickerField extends StatelessWidget {
  final bool hasLocation;
  final String? locationLabel;
  final VoidCallback onTap;
  final VoidCallback onClear;

  const LocationPickerField({
    super.key,
    required this.hasLocation,
    this.locationLabel,
    required this.onTap,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 16.h),
        decoration: BoxDecoration(
          color: AppColors.fieldFill,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(
            color: hasLocation ? AppColors.success : AppColors.fieldBorder,
          ),
        ),
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
                hasLocation
                    ? (locationLabel ?? l10n.locationSelected)
                    : l10n.selectLocationOnMap,
                style: TextStyle(
                  fontSize: 15.sp,
                  color: hasLocation
                      ? AppColors.textPrimary
                      : AppColors.textHint,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (hasLocation)
              GestureDetector(
                onTap: onClear,
                child: Icon(
                  Icons.close,
                  size: 18.r,
                  color: AppColors.textSecondary,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// An "or" divider used between address field and location picker.
class OrDivider extends StatelessWidget {
  const OrDivider({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Row(
      children: [
        const Expanded(child: Divider(color: AppColors.fieldBorder)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: Text(
            l10n.orText,
            style: TextStyle(
              fontSize: 13.sp,
              color: AppColors.textSecondary,
            ),
          ),
        ),
        const Expanded(child: Divider(color: AppColors.fieldBorder)),
      ],
    );
  }
}
