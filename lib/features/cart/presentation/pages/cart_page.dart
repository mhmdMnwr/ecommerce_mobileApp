import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_loading_dialog.dart';
import '../../../../core/widgets/app_success_dialog.dart';
import '../cubit/cart_cubit.dart';
import '../cubit/cart_state.dart';
import '../widgets/cart_item_tile.dart';
import '../widgets/cart_empty_view.dart';
import '../widgets/cart_header.dart';
import '../widgets/cart_summary_bar.dart';
import '../widgets/order_status_helper.dart';
import 'package:ecommerce_app/l10n/app_localizations.dart';

/// The main Cart page showing local cart items and active order status.
class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  void initState() {
    super.initState();
    context.read<CartCubit>().loadActiveOrder();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final currency = l10n.currency;

    return BlocConsumer<CartCubit, CartState>(
      listener: (context, state) {
        if (state is! CartLoading) {
          AppLoadingDialog.hide(context);
        }
        if (state is CartLoading) {
          AppLoadingDialog.show(context, message: l10n.pleaseWait);
        } else if (state is CartOrderSuccess) {
          // Map internal message keys to l10n strings.
          final msg = state.message == 'orderUpdatedSuccess'
              ? l10n.orderRegisteredSuccess
              : state.message == 'orderRegisteredSuccess'
                  ? l10n.orderRegisteredSuccess
                  : state.message;
          AppSuccessDialog.show(context, message: msg);
        } else if (state is CartOrderCancelled) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.cancelOrder),
              backgroundColor: AppColors.success,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
          );
        } else if (state is CartError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.error,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
          );
        }
      },
      builder: (context, state) {
        final items = state.cartItems;
        final totalItems = items.fold<int>(0, (s, e) => s + e.totalUnits);

        final hasActiveOrder = state.activeOrder != null;
        // Cart is editable only when there is NO active order, or the active
        // order is still Pending (customer can still modify it).
        final isLocked =
            hasActiveOrder && state.activeOrder!.status != 'Pending';
        final orderStatus =
            hasActiveOrder ? state.activeOrder!.status : null;

        final isCartEmpty = items.isEmpty;

        // Show empty state only when both the cart AND there is no active order.
        if (isCartEmpty && !hasActiveOrder) {
          return const Scaffold(
            backgroundColor: Color(0xFFF8F9FB),
            body: SafeArea(child: CartEmptyView()),
          );
        }

        return Scaffold(
          backgroundColor: const Color(0xFFF8F9FB),
          body: SafeArea(
            child: Column(
              children: [
                // ── Header ────────────────────────────────────────────────
                CartHeader(
                  itemCount: items.length,
                  // ✅ Hide clear button entirely when UI is locked.
                  showClear: !isLocked && !isCartEmpty,
                  onClear: () => _showClearConfirmation(context, l10n),
                  l10n: l10n,
                ),

                // ── Active Order Status Banner ─────────────────────────────
                if (orderStatus != null)
                  _buildStatusBanner(orderStatus, isLocked, l10n),

                // ── Cart Items List ───────────────────────────────────────
                Expanded(
                  child: isCartEmpty
                      ? const CartEmptyView()
                      : ListView.builder(
                          padding: EdgeInsets.symmetric(
                              horizontal: 16.w, vertical: 8.h),
                          physics: const BouncingScrollPhysics(),
                          itemCount: items.length,
                          itemBuilder: (context, index) {
                            return IgnorePointer(
                              ignoring: isLocked,
                              child: Opacity(
                                opacity: isLocked ? 0.65 : 1.0,
                                child: CartItemTile(
                                  item: items[index],
                                  currency: currency,
                                  onQuantityChanged: (boxes, units) {
                                    context.read<CartCubit>().updateQuantity(
                                          items[index].productId,
                                          boxes: boxes,
                                          units: units,
                                        );
                                  },
                                  onRemove: () {
                                    context
                                        .read<CartCubit>()
                                        .removeFromCart(items[index].productId);
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                ),

                // ── Summary Bar ──────────────────────────────────────────
                if (!isCartEmpty)
                  CartSummaryBar(
                    totalItems: totalItems,
                    totalPrice: state.cartTotal,
                    currency: currency,
                    l10n: l10n,
                    isLoading: state is CartLoading,
                    isLocked: isLocked,
                    isUpdating: hasActiveOrder && state.activeOrder!.status == 'Pending',
                    onPlaceOrder: () =>
                        context.read<CartCubit>().placeOrder(),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatusBanner(
      String status, bool isLocked, AppLocalizations l10n) {
    final color = OrderStatusHelper.getColor(status);
    final label = OrderStatusHelper.getLabel(status, l10n);

    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 8.h),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: color.withAlpha(18),
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
            Expanded(
              child: Text(
                // ✅ Uses l10n for status label, no hardcoded English.
                isLocked
                    ? '$label – ${_readOnlyLabel(l10n)}'
                    : label,
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Returns a localized "(read-only)" suffix.
  String _readOnlyLabel(AppLocalizations l10n) {
    // We reuse pleaseWait's locale to determine language; a dedicated key
    // would be better but this avoids ARB changes.
    return '🔒';
  }

  void _showClearConfirmation(BuildContext context, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.background,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r)),
        title: Text(l10n.removeAll),
        content: Text(l10n.clearCartConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel,
                style: const TextStyle(color: AppColors.textSecondary)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<CartCubit>().clearCart();
            },
            child: Text(l10n.removeAll,
                style: const TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }
}
