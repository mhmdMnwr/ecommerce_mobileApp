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
import 'package:ecommerce_app/l10n/app_localizations.dart';

/// The main Cart page showing local cart items and order placement.
class CartPage extends StatelessWidget {
  const CartPage({super.key});

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
          AppLoadingDialog.show(context, message: l10n.pleaseWaitOrderRegistered);
        } else if (state is CartOrderSuccess) {
          AppSuccessDialog.show(context, message: l10n.orderRegisteredSuccess);
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
        final totalItems = items.fold<int>(0, (s, e) => s + e.quantity);

        return Scaffold(
          backgroundColor: const Color(0xFFF8F9FB), // Very light gray/blue background from mockup
          body: SafeArea(
            child: items.isEmpty
                ? const CartEmptyView()
                : Column(
                    children: [
                      CartHeader(
                        itemCount: items.length,
                        onClear: () => _showClearConfirmation(context, l10n),
                        l10n: l10n,
                      ),
                      Expanded(
                        child: ListView.builder(
                          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                          physics: const BouncingScrollPhysics(),
                          itemCount: items.length,
                          itemBuilder: (context, index) {
                            return CartItemTile(
                              item: items[index],
                              currency: currency,
                              onQuantityChanged: (newQty) {
                                context.read<CartCubit>().updateQuantity(items[index].productId, newQty);
                              },
                              onRemove: () {
                                context.read<CartCubit>().removeFromCart(items[index].productId);
                              },
                            );
                          },
                        ),
                      ),
                      CartSummaryBar(
                        totalItems: totalItems,
                        totalPrice: state.cartTotal,
                        deliveryFee: 500, // Fixed delivery fee for now
                        currency: currency,
                        l10n: l10n,
                        isLoading: state is CartLoading,
                        onPlaceOrder: () => context.read<CartCubit>().placeOrder(),
                      ),
                    ],
                  ),
          ),
        );
      },
    );
  }

  void _showClearConfirmation(BuildContext context, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.background,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
        title: Text(l10n.removeAll),
        content: Text(l10n.clearCartConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel, style: const TextStyle(color: AppColors.textSecondary)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<CartCubit>().clearCart();
            },
            child: Text(l10n.removeAll, style: const TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }
}
