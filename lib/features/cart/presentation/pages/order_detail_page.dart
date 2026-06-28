import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_colors.dart';
import '../../data/models/order_model.dart';
import '../widgets/order_status_helper.dart';
import 'package:ecommerce_app/l10n/app_localizations.dart';

/// Full-screen page that displays all details for a single order.
class OrderDetailPage extends StatelessWidget {
  final OrderModel order;
  final String currency;

  const OrderDetailPage({
    super.key,
    required this.order,
    required this.currency,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final statusColor = OrderStatusHelper.getColor(order.status);
    final statusLabel = OrderStatusHelper.getLabel(order.status, l10n);
    final dateFormat = DateFormat('dd MMMM yyyy');
    final timeFormat = DateFormat('HH:mm');

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            size: 18.r,
            color: AppColors.textPrimary,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          l10n.orderInfo,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics:
            const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Status badge ──────────────────────────────────
              _buildStatusRow(statusLabel, statusColor),

              SizedBox(height: 20.h),

              // ── Date ──────────────────────────────────────────
              if (order.createdAt != null) ...[
                _buildInfoRow(
                  l10n.date,
                  dateFormat.format(order.createdAt!),
                ),
                SizedBox(height: 6.h),
                _buildInfoRow(
                  l10n.time,
                  timeFormat.format(order.createdAt!),
                ),
                SizedBox(height: 20.h),
              ],

              // ── Delivered date ────────────────────────────────
              if (order.deliveredAt != null) ...[
                _buildInfoRow(
                  l10n.statusDelivered,
                  dateFormat.format(order.deliveredAt!),
                ),
                SizedBox(height: 20.h),
              ],

              // ── Products Table ────────────────────────────────
              _buildProductsTable(l10n),

              SizedBox(height: 24.h),

              // ── Grand Total ───────────────────────────────────
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                decoration: BoxDecoration(
                  color: AppColors.primary.withAlpha(12),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                      color: AppColors.primary.withAlpha(40), width: 1),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${l10n.total} :',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      '${order.totalAmount.toStringAsFixed(2)} $currency',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 24.h),

              // ── Comment (if any) ──────────────────────────────
              if (order.comment != null && order.comment!.isNotEmpty) ...[
                Text(
                  l10n.comment,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 8.h),
                Container(
                  width: double.infinity,
                  padding:
                      EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(10.r),
                    border:
                        Border.all(color: AppColors.fieldBorder, width: 1),
                  ),
                  child: Text(
                    order.comment!,
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: AppColors.textBody,
                      height: 1.5,
                    ),
                  ),
                ),
                SizedBox(height: 24.h),
              ],
            ],
          ),
        ),
      ),
    );
  }

  // ── Status Row ──────────────────────────────────────────────────────
  Widget _buildStatusRow(String label, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: color.withAlpha(15),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: color.withAlpha(50), width: 1),
      ),
      child: Row(
        children: [
          Container(
            width: 8.r,
            height: 8.r,
            decoration: BoxDecoration(shape: BoxShape.circle, color: color),
          ),
          SizedBox(width: 10.w),
          Text(
            label,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  // ── Info Row (Date : value) ─────────────────────────────────────────
  Widget _buildInfoRow(String label, String value) {
    return Row(
      children: [
        Text(
          '$label :',
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(width: 12.w),
        Text(
          value,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
            color: AppColors.textBody,
          ),
        ),
      ],
    );
  }

  // ── Products Table ──────────────────────────────────────────────────
  Widget _buildProductsTable(AppLocalizations l10n) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.fieldBorder, width: 1),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.r),
        child: Column(
          children: [
            // ── Table Header ───────────────────────────────────
            Container(
              color: AppColors.surface,
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
              child: Row(
                children: [
                  _headerCell(l10n.product, flex: 3),
                  _headerCell(l10n.quantity, flex: 4),
                  _headerCell(l10n.unitPrice, flex: 2),
                  _headerCell(l10n.total, flex: 2, align: TextAlign.end),
                ],
              ),
            ),

            // ── Table Rows ─────────────────────────────────────
            ...List.generate(order.items.length, (index) {
              final item = order.items[index];
              final isEven = index.isEven;

              // Calculate boxes and remainder
              final unitsPerBox = item.units > 0 ? item.units : 1;
              final boxes = item.quantity ~/ unitsPerBox;
              final remainder = item.quantity % unitsPerBox;
              final totalQty = item.quantity;

              // Build quantity string: "2×24 + 3 = 51"
              String quantityStr;
              if (unitsPerBox <= 1) {
                quantityStr = '$totalQty';
              } else if (remainder == 0) {
                quantityStr = '$boxes×$unitsPerBox = $totalQty';
              } else if (boxes == 0) {
                quantityStr = '$remainder = $totalQty';
              } else {
                quantityStr = '$boxes×$unitsPerBox + $remainder = $totalQty';
              }

              final lineTotal = item.lineTotal;

              return Container(
                color: isEven
                    ? AppColors.background
                    : AppColors.surface.withAlpha(120),
                padding:
                    EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product name
                    Expanded(
                      flex: 3,
                      child: Text(
                        item.title ?? '-',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textPrimary,
                          height: 1.4,
                        ),
                      ),
                    ),
                    // Quantity formula
                    Expanded(
                      flex: 4,
                      child: Text(
                        quantityStr,
                        style: TextStyle(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textBody,
                        ),
                      ),
                    ),
                    // Unit price
                    Expanded(
                      flex: 2,
                      child: Text(
                        item.price.toStringAsFixed(2),
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textBody,
                        ),
                      ),
                    ),
                    // Line total
                    Expanded(
                      flex: 2,
                      child: Text(
                        lineTotal.toStringAsFixed(2),
                        textAlign: TextAlign.end,
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _headerCell(String text, {int flex = 1, TextAlign align = TextAlign.start}) {
    return Expanded(
      flex: flex,
      child: Text(
        text,
        textAlign: align,
        style: TextStyle(
          fontSize: 12.sp,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }
}
