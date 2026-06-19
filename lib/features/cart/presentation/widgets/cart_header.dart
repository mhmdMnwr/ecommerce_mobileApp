import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_colors.dart';
import 'package:ecommerce_app/l10n/app_localizations.dart';

class CartHeader extends StatelessWidget {
  final int itemCount;
  final VoidCallback onClear;
  final AppLocalizations l10n;

  const CartHeader({
    super.key,
    required this.itemCount,
    required this.onClear,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 8.h),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.maybePop(context),
            child: Icon(
              Icons.arrow_back,
              size: 24.r,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(width: 16.w),
          Text(
            '${l10n.cartItems} (${itemCount.toString().padLeft(2, '0')})',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: onClear,
            child: Text(
              l10n.removeAll,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
