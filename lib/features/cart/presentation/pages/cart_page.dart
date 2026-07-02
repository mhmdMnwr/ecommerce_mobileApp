import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_loading_dialog.dart';
import '../../../../core/widgets/app_success_dialog.dart';
import '../cubit/cart_cubit.dart';
import '../cubit/cart_state.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../auth/presentation/cubit/auth_state.dart';
import '../../../../core/utils/auth_message_translator.dart';
import '../../data/models/order_model.dart';
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
  final TextEditingController _commentController = TextEditingController();
  OrderModel? _lastActiveOrder;
  Timer? _statusPollTimer;

  @override
  void initState() {
    super.initState();
    _commentController.addListener(_onCommentChanged);
    // Initialize comment if there's already an active order in the cubit's state
    final activeOrder = context.read<CartCubit>().state.activeOrder;
    if (activeOrder != null) {
      _lastActiveOrder = activeOrder;
      _commentController.text = activeOrder.comment ?? '';
    }
    context.read<CartCubit>().loadActiveOrder();
    // Poll for order status changes every 30 seconds
    _statusPollTimer = Timer.periodic(
      const Duration(seconds: 30),
      (_) => context.read<CartCubit>().refreshActiveOrderStatus(),
    );
  }

  void _onCommentChanged() {
    setState(() {});
  }

  @override
  void dispose() {
    _statusPollTimer?.cancel();
    _commentController.removeListener(_onCommentChanged);
    _commentController.dispose();
    super.dispose();
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
              ? l10n.orderUpdatedSuccess
              : state.message == 'orderRegisteredSuccess'
              ? l10n.orderRegisteredSuccess
              : translateAuthMessage(context, state.message);
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
          if (!context.mounted || context.read<AuthCubit>().state is AuthUnauthenticated) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(translateAuthMessage(context, state.message)),
              backgroundColor: AppColors.error,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
          );
        }

        // Update comment controller from active order
        if (state.activeOrder != null) {
          if (state.activeOrder?.id != _lastActiveOrder?.id) {
            _lastActiveOrder = state.activeOrder;
            final backendComment = state.activeOrder!.comment ?? '';
            print('DEBUG UI: Syncing comment from backend: "$backendComment"');
            if (_commentController.text != backendComment) {
              _commentController.text = backendComment;
            }
          }
        } else {
          _lastActiveOrder = null;
          if (state is CartOrderSuccess || state is CartOrderCancelled) {
            _commentController.clear();
          }
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
        final orderStatus = hasActiveOrder ? state.activeOrder!.status : null;

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

                // ── Comment Section ───────────────────────────────────────
                if (!isLocked && !isCartEmpty)
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 8.h,
                    ),
                    child: InkWell(
                      onTap: () => _showCommentDialog(context, l10n),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 12.h,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(
                            color: AppColors.primary.withAlpha(50),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.comment_outlined,
                              color: AppColors.primary,
                              size: 20.sp,
                            ),
                            SizedBox(width: 10.w),
                            Expanded(
                              child: Text(
                                _commentController.text.isEmpty
                                    ? l10n.addOrderComment
                                    : _commentController.text,
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: _commentController.text.isEmpty
                                      ? AppColors.textSecondary
                                      : AppColors.textPrimary,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Icon(
                              Icons.edit,
                              color: AppColors.textSecondary,
                              size: 16.sp,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                // ── Cart Items List ───────────────────────────────────────
                Expanded(
                  child: isCartEmpty
                      ? const CartEmptyView()
                      : ListView.builder(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 8.h,
                          ),
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
                                  onQuantityChanged: (boxes, units, weight) {
                                    context.read<CartCubit>().updateQuantity(
                                      items[index].productId,
                                      boxes: boxes,
                                      units: units,
                                      weight: weight,
                                    );
                                  },
                                  onRemove: () {
                                    context.read<CartCubit>().removeFromCart(
                                      items[index].productId,
                                    );
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
                    isUpdating:
                        hasActiveOrder &&
                        state.activeOrder!.status == 'Pending',
                    onPlaceOrder:
                        (hasActiveOrder &&
                            state.activeOrder!.status == 'Pending' &&
                            !state.isCartModified &&
                            _commentController.text.trim() ==
                                (state.activeOrder!.comment ?? ''))
                        ? null
                        : () {
                            print('DEBUG UI CLICK UPDATE ORDER: "${_commentController.text.trim()}"');
                            context.read<CartCubit>().placeOrder(
                              comment: _commentController.text.trim(),
                            );
                          },
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showCommentDialog(BuildContext context, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.background,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        title: Text(
          l10n.orderCommentTitle,
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
            fontSize: 16.sp,
          ),
        ),
        content: TextField(
          controller: _commentController,
          maxLines: 3,
          decoration: InputDecoration(
            hintText: l10n.orderCommentHint,
            hintStyle: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14.sp,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: AppColors.primary.withAlpha(50)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: AppColors.primary.withAlpha(50)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: AppColors.primary),
            ),
          ),
          style: TextStyle(fontSize: 14.sp, color: AppColors.textPrimary),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              setState(() {});
            },
            child: Text(
              l10n.cancel,
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              setState(() {});
            },
            child: Text(
              l10n.save,
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBanner(
    String status,
    bool isLocked,
    AppLocalizations l10n,
  ) {
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
                isLocked ? '$label – ${_readOnlyLabel(l10n)}' : label,
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
    final cartCubit = context.read<CartCubit>();
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.background,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        title: Text(
          l10n.removeAll,
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
            fontSize: 16.sp,
          ),
        ),
        content: Text(
          l10n.clearCartConfirm,
          style: TextStyle(color: AppColors.textSecondary, fontSize: 14.sp),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(
              l10n.cancel,
              style: TextStyle(color: AppColors.textSecondary, fontSize: 14.sp),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              cartCubit.clearCart();
            },
            child: Text(
              l10n.removeAll,
              style: TextStyle(
                color: AppColors.error,
                fontWeight: FontWeight.w600,
                fontSize: 14.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
