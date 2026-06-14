import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/theme_cubit.dart';

/// Popup dialog for selecting the app theme.
class ThemeDialog extends StatelessWidget {
  final ThemeCubit themeCubit;

  const ThemeDialog({super.key, required this.themeCubit});

  static const _options = [
    (mode: ThemeMode.system, label: 'System', icon: Icons.brightness_auto),
    (mode: ThemeMode.light, label: 'Light', icon: Icons.light_mode_outlined),
    (mode: ThemeMode.dark, label: 'Dark', icon: Icons.dark_mode_outlined),
  ];

  @override
  Widget build(BuildContext context) {
    final current = themeCubit.themeMode;

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
              'Theme',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 16.h),
            ..._options.map((opt) {
              final selected = opt.mode == current;

              return ListTile(
                leading: Icon(opt.icon, size: 22.r,
                    color: selected
                        ? AppColors.primary
                        : AppColors.textMuted),
                title: Text(
                  opt.label,
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
                  themeCubit.setThemeMode(opt.mode);
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
