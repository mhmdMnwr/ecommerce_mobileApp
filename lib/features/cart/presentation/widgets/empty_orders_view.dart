import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_colors.dart';
import 'package:ecommerce_app/l10n/app_localizations.dart';

class EmptyOrdersView extends StatelessWidget {
  final AppLocalizations l10n;

  const EmptyOrdersView({super.key, required this.l10n});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.receipt_long_outlined,
            size: 64.r,
            color: AppColors.fieldBorder,
          ),
          SizedBox(height: 16.h),
          Text(
            l10n.noOrders,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
