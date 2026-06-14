import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/locale/locale_cubit.dart';
import '../../../../core/theme/app_colors.dart';
import 'package:ecommerce_app/l10n/app_localizations.dart';

/// Popup dialog for selecting the app language.
class LanguageDialog extends StatelessWidget {
  final LocaleCubit localeCubit;

  const LanguageDialog({super.key, required this.localeCubit});

  @override
  Widget build(BuildContext context) {
    final currentCode = localeCubit.locale.languageCode;

    return Dialog(
      backgroundColor: AppColors.background,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      insetPadding: EdgeInsets.symmetric(horizontal: 40.w),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 8.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              AppLocalizations.of(context)!.language,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 16.h),
            ...LocaleCubit.supportedLocales.map((locale) {
              final code = locale.languageCode;
              final label = LocaleCubit.localeLabels[code] ?? code;
              final selected = code == currentCode;

              return ListTile(
                title: Text(
                  label,
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight:
                        selected ? FontWeight.w600 : FontWeight.w400,
                    color: selected
                        ? AppColors.primary
                        : AppColors.textPrimary,
                  ),
                ),
                trailing: selected
                    ? Icon(Icons.check_circle,
                        color: AppColors.primary, size: 22.r)
                    : null,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r)),
                onTap: () {
                  localeCubit.setLocale(locale);
                  Navigator.pop(context);
                },
              );
            }),
          ],
        ),
      ),
    );
  }
}
