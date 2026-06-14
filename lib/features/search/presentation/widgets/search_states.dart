import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_colors.dart';
import 'package:ecommerce_app/l10n/app_localizations.dart';

/// Displayed when the user hasn't searched yet.
class SearchEmptyState extends StatelessWidget {
  final String label;
  const SearchEmptyState({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Container(
          width: 80.r,
          height: 80.r,
          decoration: BoxDecoration(
            color: AppColors.primary.withAlpha(12),
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.search_rounded, size: 40.r, color: AppColors.primary.withAlpha(120)),
        ),
        SizedBox(height: 20.h),
        Text(label,
            style: TextStyle(fontSize: 16.sp, color: AppColors.textSecondary)),
      ]),
    );
  }
}

/// Displayed when a search returns zero results.
class SearchNoResults extends StatelessWidget {
  const SearchNoResults({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Container(
          width: 80.r,
          height: 80.r,
          decoration: BoxDecoration(
            color: AppColors.fieldBorder.withAlpha(40),
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.search_off_rounded, size: 40.r, color: AppColors.fieldBorder),
        ),
        SizedBox(height: 20.h),
        Text(l10n.noResults,
            style: TextStyle(fontSize: 16.sp, color: AppColors.textSecondary)),
      ]),
    );
  }
}

/// Displayed when a search request fails.
class SearchErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const SearchErrorState({
    super.key,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32.w),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(
            width: 80.r,
            height: 80.r,
            decoration: BoxDecoration(
              color: AppColors.error.withAlpha(15),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.error_outline, size: 40.r, color: AppColors.error),
          ),
          SizedBox(height: 20.h),
          Text(message,
              textAlign: TextAlign.center,
              style:
                  TextStyle(color: AppColors.textSecondary, fontSize: 14.sp)),
          SizedBox(height: 24.h),
          TextButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh),
            label: Text(l10n.retry),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.primary,
            ),
          ),
        ]),
      ),
    );
  }
}
