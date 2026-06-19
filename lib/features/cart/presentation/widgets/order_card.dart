import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_colors.dart';
import '../../data/models/order_model.dart';
import 'package:ecommerce_app/l10n/app_localizations.dart';
import 'order_status_helper.dart';
import 'order_item_row.dart';

/// A card that displays a single order with its status and items.
class OrderCard extends StatelessWidget {
  final OrderModel order;
  final String currency;
  final VoidCallback? onCancel;

  const OrderCard({
    super.key,
    required this.order,
    required this.currency,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final dateStr = order.createdAt != null
        ? DateFormat('dd MMM yyyy – HH:mm').format(order.createdAt!)
        : '';

    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.fieldBorder.withAlpha(100), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(6),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 0),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${l10n.order} #${order.id.substring(order.id.length - 6).toUpperCase()}',
                        style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                      ),
                      SizedBox(height: 2.h),
                      Text(dateStr, style: TextStyle(fontSize: 11.sp, color: AppColors.textSecondary)),
                    ],
                  ),
                ),
                _buildStatusBadge(order.status, l10n),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10.h),
            child: Divider(height: 1, color: AppColors.fieldBorder.withAlpha(60)),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              children: [
                for (final item in order.items) ...[
                  OrderItemRow(item: item, currency: currency),
                  SizedBox(height: 6.h),
                ],
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 6.h, 16.w, 14.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(l10n.total, style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                Text('${order.totalAmount.toStringAsFixed(2)} $currency', style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w800, color: AppColors.primary)),
              ],
            ),
          ),
          _buildBottomSection(context, l10n),
        ],
      ),
    );
  }

  Widget _buildBottomSection(BuildContext context, AppLocalizations l10n) {
    final statusColor = OrderStatusHelper.getColor(order.status);
    final statusLabel = OrderStatusHelper.getLabel(order.status, l10n);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: statusColor.withAlpha(10),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(16.r)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                Container(
                  width: 8.r, height: 8.r,
                  decoration: BoxDecoration(shape: BoxShape.circle, color: statusColor),
                ),
                SizedBox(width: 8.w),
                Text(
                  statusLabel,
                  style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600, color: statusColor),
                ),
              ],
            ),
          ),
          if (order.isPending && onCancel != null)
            GestureDetector(
              onTap: onCancel,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(color: AppColors.error.withAlpha(120)),
                ),
                child: Text(
                  l10n.cancelOrder,
                  style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600, color: AppColors.error),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String status, AppLocalizations l10n) {
    final color = OrderStatusHelper.getColor(status);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: color.withAlpha(15),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: color.withAlpha(50), width: 1),
      ),
      child: Text(
        OrderStatusHelper.getLabel(status, l10n),
        style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.w600, color: color),
      ),
    );
  }
}
