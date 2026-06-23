import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_colors.dart';
import 'package:ecommerce_app/l10n/app_localizations.dart';

/// Sticky bottom bar with total preview and add-to-cart button.
class ProductBottomBar extends StatelessWidget {
  final double total;
  final bool hasItems;
  final String currency;
  final AppLocalizations l10n;
  final VoidCallback? onAddToCart;

  const ProductBottomBar({
    super.key,
    required this.total,
    required this.hasItems,
    required this.currency,
    required this.l10n,
    this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        24.w, 14.h, 24.w,
        14.h + MediaQuery.of(context).padding.bottom,
      ),
      decoration: BoxDecoration(
        color: AppColors.background,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 20,
            offset: const Offset(0, -6),
          ),
        ],
      ),
      child: Row(
        children: [
          if (hasItems) ...[
            _buildTotalPreview(),
            const Spacer(),
          ],
          _buildAddButton(),
        ],
      ),
    );
  }

  Widget _buildTotalPreview() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Total',
          style: TextStyle(
            fontSize: 11.sp,
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 2.h),
        Text(
          '${total.toStringAsFixed(2)} $currency',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildAddButton() {
    return Expanded(
      flex: hasItems ? 0 : 1,
      child: SizedBox(
        height: 52.h,
        width: hasItems ? null : double.infinity,
        child: ElevatedButton.icon(
          onPressed: onAddToCart,
          icon: Icon(Icons.shopping_cart_outlined, size: 20.r),
          label: Text(
            l10n.addToCart,
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.3,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: hasItems
                ? AppColors.primary
                : AppColors.primary.withAlpha(180),
            foregroundColor: AppColors.background,
            disabledBackgroundColor: AppColors.primary.withAlpha(160),
            disabledForegroundColor: Colors.white.withAlpha(220),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.r),
            ),
            padding: EdgeInsets.symmetric(horizontal: 28.w),
            elevation: 0,
          ),
        ),
      ),
    );
  }
}
