import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_colors.dart';
import '../../data/models/order_model.dart';
import 'package:ecommerce_app/l10n/app_localizations.dart';

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
        Builder(
          builder: (context) {
            final l10n = AppLocalizations.of(context)!;
            final uPerBox = item.units > 0 ? item.units : 1;
            final boxes = item.quantity ~/ uPerBox;
            final remUnits = item.quantity % uPerBox;

            final List<String> parts = [];
            if (boxes > 0) parts.add('$boxes ${l10n.boxes}');
            if (remUnits > 0 || parts.isEmpty) parts.add('$remUnits ${l10n.units}');

            return Text(
              parts.join(', '),
              style: TextStyle(
                fontSize: 12.sp,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            );
          }
        ),
        SizedBox(width: 16.w),
        Text(
          '${item.lineTotal.toStringAsFixed(2)} $currency',
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
