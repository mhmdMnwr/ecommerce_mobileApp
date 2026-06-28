import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_loading_indicator.dart';
import '../../data/models/order_model.dart';
import '../cubit/cart_cubit.dart';
import '../cubit/cart_state.dart';
import '../widgets/empty_orders_view.dart';
import '../widgets/orders_error_view.dart';
import '../widgets/order_status_helper.dart';
import 'package:ecommerce_app/l10n/app_localizations.dart';
import '../../../../core/utils/auth_message_translator.dart';
import 'order_detail_page.dart';

/// Full-screen paginated Order History page.
class OrdersHistoryPage extends StatefulWidget {
  const OrdersHistoryPage({super.key});

  @override
  State<OrdersHistoryPage> createState() => _OrdersHistoryPageState();
}

class _OrdersHistoryPageState extends State<OrdersHistoryPage> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<CartCubit>().loadMyOrders();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    // Trigger load more when 200px from the bottom.
    if (currentScroll >= maxScroll - 200) {
      context.read<CartCubit>().loadMoreOrders();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        title: Text(
          l10n.ordersHistory,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shadowColor: Colors.black.withAlpha(20),
        scrolledUnderElevation: 1,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            size: 18.r,
            color: AppColors.textPrimary,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocConsumer<CartCubit, CartState>(
        listener: (context, state) {
          if (state is CartOrderCancelled) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(l10n.cancelOrder),
                backgroundColor: AppColors.success,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
              ),
            );
            // Reload after cancel.
            context.read<CartCubit>().loadMyOrders();
          } else if (state is CartError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(translateAuthMessage(context, state.message)),
                backgroundColor: AppColors.error,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is CartLoading && state is! CartOrdersLoaded) {
            return const Center(child: CircularProgressIndicator(color: AppColors.primary));
          }

          if (state is CartError && state is! CartOrdersLoaded) {
            return OrdersErrorView(
              message: translateAuthMessage(context, state.message),
              l10n: l10n,
              onRetry: () => context.read<CartCubit>().loadMyOrders(),
            );
          }

          if (state is CartOrdersLoaded) {
            final orders = state.orders;
            if (orders.isEmpty) return EmptyOrdersView(l10n: l10n);

            return RefreshIndicator(
              onRefresh: () => context.read<CartCubit>().loadMyOrders(),
              color: AppColors.primary,
              child: ListView.separated(
                controller: _scrollController,
                padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 32.h),
                physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
                itemCount: orders.length + (state.hasMore ? 1 : 0),
                separatorBuilder: (context2, idx) => SizedBox(height: 12.h),
                itemBuilder: (context, index) {
                  if (index == orders.length) {
                    // Footer loader.
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                      child: const Center(child: AppLoadingIndicator()),
                    );
                  }
                  return _OrderHistoryCard(
                    order: orders[index],
                    currency: l10n.currency,
                    l10n: l10n,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => OrderDetailPage(
                            order: orders[index],
                            currency: l10n.currency,
                          ),
                        ),
                      );
                    },
                    onCancel: orders[index].isPending
                        ? () => _confirmCancel(context, orders[index], l10n)
                        : null,
                  );
                },
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  void _confirmCancel(BuildContext context, OrderModel order, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.background,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
        title: Text(
          l10n.cancelOrder,
          style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600, fontSize: 16.sp),
        ),
        content: Text(
          l10n.cancelOrderConfirm,
          style: TextStyle(color: AppColors.textSecondary, fontSize: 14.sp),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel, style: TextStyle(color: AppColors.textSecondary, fontSize: 14.sp)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<CartCubit>().cancelOrder(order.id);
            },
            child: Text(l10n.cancelOrder, style: TextStyle(color: AppColors.error, fontWeight: FontWeight.w600, fontSize: 14.sp)),
          ),
        ],
      ),
    );
  }
}

/// A compact but rich order summary card.
class _OrderHistoryCard extends StatelessWidget {
  final OrderModel order;
  final String currency;
  final AppLocalizations l10n;
  final VoidCallback? onTap;
  final VoidCallback? onCancel;

  const _OrderHistoryCard({
    required this.order,
    required this.currency,
    required this.l10n,
    this.onTap,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    final statusColor = OrderStatusHelper.getColor(order.status);
    final statusLabel = OrderStatusHelper.getLabel(order.status, l10n);
    final dateFormat = DateFormat('dd MMM yyyy');
    final timeFormat = DateFormat('HH:mm');

    final orderDate = order.createdAt;
    final deliveredDate = order.deliveredAt;

    return GestureDetector(
      onTap: onTap,
      child: Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(8),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Top row: Order ID + Status badge ──────────────────────────
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 0),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    '${l10n.order} #${order.id.substring(order.id.length.clamp(6, order.id.length) - 6).toUpperCase()}',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                _StatusBadge(label: statusLabel, color: statusColor),
              ],
            ),
          ),

          SizedBox(height: 12.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Divider(height: 1, color: AppColors.fieldBorder.withAlpha(80)),
          ),
          SizedBox(height: 12.h),

          // ── Info rows ─────────────────────────────────────────────────
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              children: [
                // Order date
                if (orderDate != null)
                  _InfoRow(
                    icon: Icons.calendar_today_outlined,
                    label: '${dateFormat.format(orderDate)}  ·  ${timeFormat.format(orderDate)}',
                    color: AppColors.textSecondary,
                  ),

                SizedBox(height: 8.h),

                // Delivered date (only if delivered)
                if (deliveredDate != null) ...[
                  _InfoRow(
                    icon: Icons.local_shipping_outlined,
                    label: '${l10n.statusDelivered}: ${dateFormat.format(deliveredDate)}',
                    color: AppColors.success,
                  ),
                  SizedBox(height: 8.h),
                ],

                // Number of products
                _InfoRow(
                  icon: Icons.inventory_2_outlined,
                  label: '${order.items.length} ${l10n.products}',
                  color: AppColors.textSecondary,
                ),

                SizedBox(height: 8.h),

                // Total price
                _InfoRow(
                  icon: Icons.attach_money_outlined,
                  label: '${order.totalAmount.toStringAsFixed(2)} $currency',
                  color: AppColors.primary,
                  isBold: true,
                ),
              ],
            ),
          ),

          SizedBox(height: 12.h),

          // ── Cancel button (Pending only) ───────────────────────────────
          if (onCancel != null)
            Material(
              color: AppColors.error.withAlpha(8),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(16.r)),
              child: InkWell(
                onTap: onCancel,
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(16.r)),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.cancel_outlined, size: 16.r, color: AppColors.error),
                      SizedBox(width: 6.w),
                      Text(
                        l10n.cancelOrder,
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.error,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          else
            SizedBox(height: 14.h),
        ],
      ),
    ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String label;
  final Color color;

  const _StatusBadge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: color.withAlpha(18),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: color.withAlpha(60), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6.r,
            height: 6.r,
            decoration: BoxDecoration(shape: BoxShape.circle, color: color),
          ),
          SizedBox(width: 5.w),
          Text(
            label,
            style: TextStyle(
              fontSize: 11.sp,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final bool isBold;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.color,
    this.isBold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 15.r, color: color),
        SizedBox(width: 8.w),
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13.sp,
              color: color,
              fontWeight: isBold ? FontWeight.w700 : FontWeight.w500,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
