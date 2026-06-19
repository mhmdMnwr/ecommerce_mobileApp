import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_colors.dart';
import 'package:ecommerce_app/l10n/app_localizations.dart';

class CartSummaryBar extends StatelessWidget {
  final int totalItems;
  final double totalPrice;
  final double deliveryFee;
  final String currency;
  final AppLocalizations l10n;
  final VoidCallback? onPlaceOrder;
  final bool isLoading;

  const CartSummaryBar({
    super.key,
    required this.totalItems,
    required this.totalPrice,
    required this.deliveryFee,
    required this.currency,
    required this.l10n,
    this.onPlaceOrder,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final grandTotal = totalPrice + deliveryFee;

    return Container(
      padding: EdgeInsets.fromLTRB(24.w, 20.h, 24.w, 20.h + MediaQuery.of(context).padding.bottom),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(13),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _summaryRow('${l10n.productsTotal} (${totalItems.toString().padLeft(2, '0')})', '${totalPrice.toInt()} $currency'),
          SizedBox(height: 8.h),
          _summaryRow(l10n.delivery, '${deliveryFee.toInt()} $currency'),
          SizedBox(height: 12.h),
          _summaryRow(
            l10n.total,
            '${grandTotal.toInt()} $currency',
            isBold: true,
            fontSize: 18.sp,
          ),
          SizedBox(height: 20.h),
          SizedBox(
            width: double.infinity,
            height: 54.h,
            child: ElevatedButton(
              onPressed: isLoading ? null : onPlaceOrder,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF8B92A5), // Gray color matching the mockup
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                elevation: 0,
              ),
              child: Text(
                'waiting for delivery', // Matching the exact text from mockup
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _summaryRow(String label, String value, {bool isBold = false, double? fontSize}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: fontSize ?? 14.sp,
            fontWeight: isBold ? FontWeight.w800 : FontWeight.w400,
            color: isBold ? AppColors.textPrimary : AppColors.textSecondary,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: fontSize ?? 14.sp,
            fontWeight: isBold ? FontWeight.w800 : FontWeight.w500,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
