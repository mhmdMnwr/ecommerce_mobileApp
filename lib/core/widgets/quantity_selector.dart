import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theme/app_colors.dart';

/// Reusable quantity selector card with title, +/- buttons and value.
///
/// Used on both the product page and the cart item tile.
class QuantitySelector extends StatelessWidget {
  final String title;
  final int value;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const QuantitySelector({
    super.key,
    required this.title,
    required this.value,
    required this.onIncrement,
    required this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: value > 0
              ? AppColors.primary.withAlpha(60)
              : AppColors.fieldBorder.withAlpha(100),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
              letterSpacing: 0.3,
            ),
          ),
          SizedBox(height: 10.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _roundButton(
                Icons.remove,
                onDecrement,
                enabled: value > 0,
              ),
              Container(
                constraints: BoxConstraints(minWidth: 40.w),
                alignment: Alignment.center,
                child: Text(
                  '$value',
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w800,
                    color: value > 0
                        ? AppColors.primary
                        : AppColors.textPrimary,
                  ),
                ),
              ),
              _roundButton(
                Icons.add,
                onIncrement,
                isAdd: true,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _roundButton(
    IconData icon,
    VoidCallback onTap, {
    bool isAdd = false,
    bool enabled = true,
  }) {
    final color = isAdd
        ? AppColors.primary
        : (enabled ? AppColors.textSecondary : AppColors.fieldBorder);
    final bg = isAdd
        ? AppColors.primary.withAlpha(15)
        : (enabled ? AppColors.surface : Colors.transparent);

    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Container(
        width: 32.r,
        height: 32.r,
        decoration: BoxDecoration(
          color: bg,
          shape: BoxShape.circle,
          border: Border.all(
            color: color.withAlpha(isAdd ? 60 : 40),
            width: 1.5,
          ),
        ),
        child: Icon(icon, size: 16.r, color: color),
      ),
    );
  }
}
