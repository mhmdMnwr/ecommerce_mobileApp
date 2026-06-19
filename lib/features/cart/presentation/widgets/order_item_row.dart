import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_colors.dart';
import '../../data/models/order_model.dart';

class OrderItemRow extends StatelessWidget {
  final OrderItemModel item;
  final String currency;

  const OrderItemRow({
    super.key,
    required this.item,
    required this.currency,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            item.title ?? 'Product',
            style: TextStyle(
              fontSize: 12.sp,
              color: AppColors.textMuted,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Text(
          'x${item.quantity}',
          style: TextStyle(
            fontSize: 12.sp,
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(width: 16.w),
        Text(
          '${item.lineTotal.toInt()} $currency',
          style: TextStyle(
            fontSize: 12.sp,
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
