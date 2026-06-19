import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_loading_dialog.dart';
import '../../../../core/widgets/app_success_dialog.dart';
import '../../data/models/order_model.dart';
import '../cubit/cart_cubit.dart';
import '../cubit/cart_state.dart';
import '../widgets/order_card.dart';
import '../widgets/empty_orders_view.dart';
import '../widgets/orders_error_view.dart';
import 'package:ecommerce_app/l10n/app_localizations.dart';

/// Page that displays the user's order history with status tracking.
class OrdersHistoryPage extends StatefulWidget {
  const OrdersHistoryPage({super.key});

  @override
  State<OrdersHistoryPage> createState() => _OrdersHistoryPageState();
}

class _OrdersHistoryPageState extends State<OrdersHistoryPage> {
  @override
  void initState() {
    super.initState();
    context.read<CartCubit>().loadMyOrders();
  }

  void _handleStateChanges(BuildContext context, CartState state, AppLocalizations l10n) {
    if (state is! CartLoading) {
      AppLoadingDialog.hide(context);
    }
    if (state is CartLoading) {
      AppLoadingDialog.show(context, message: l10n.pleaseWait);
    } else if (state is CartOrderCancelled) {
      AppSuccessDialog.show(context, message: state.message);
      Future.delayed(const Duration(milliseconds: 2200), () {
        if (context.mounted) context.read<CartCubit>().loadMyOrders();
      });
    } else if (state is CartOrderUpdated) {
      AppSuccessDialog.show(context, message: state.message);
      Future.delayed(const Duration(milliseconds: 2200), () {
        if (context.mounted) context.read<CartCubit>().loadMyOrders();
      });
    } else if (state is CartError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(state.message),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final currency = l10n.currency;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          l10n.ordersHistory,
          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
        ),
        centerTitle: true,
        backgroundColor: AppColors.background,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocConsumer<CartCubit, CartState>(
        listener: (context, state) => _handleStateChanges(context, state, l10n),
        builder: (context, state) {
          if (state is CartLoading && state is! CartOrdersLoaded) {
            return const Center(child: CircularProgressIndicator(color: AppColors.primary));
          }

          if (state is CartOrdersLoaded) {
            final orders = state.orders;
            if (orders.isEmpty) return EmptyOrdersView(l10n: l10n);

            return RefreshIndicator(
              onRefresh: () => context.read<CartCubit>().loadMyOrders(),
              color: AppColors.primary,
              child: ListView.separated(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
                itemCount: orders.length,
                separatorBuilder: (context2, index2) => SizedBox(height: 12.h),
                itemBuilder: (context, index) {
                  return OrderCard(
                    order: orders[index],
                    currency: currency,
                    onCancel: orders[index].isPending ? () => _confirmCancel(context, orders[index], l10n) : null,
                  );
                },
              ),
            );
          }

          if (state is CartError) {
            return OrdersErrorView(
              message: state.message,
              l10n: l10n,
              onRetry: () => context.read<CartCubit>().loadMyOrders(),
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
        title: Text(l10n.cancelOrder),
        content: Text(l10n.cancelOrderConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel, style: const TextStyle(color: AppColors.textSecondary)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<CartCubit>().cancelOrder(order.id);
            },
            child: Text(l10n.cancelOrder, style: const TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }
}
