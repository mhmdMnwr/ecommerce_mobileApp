import 'package:equatable/equatable.dart';

import '../../data/models/cart_item_model.dart';
import '../../data/models/order_model.dart';

/// Base state for the cart feature.
abstract class CartState extends Equatable {
  /// Items currently in the local cart (pre-order).
  final List<CartItemModel> cartItems;
  /// The currently active backend order, if any.
  final OrderModel? activeOrder;

  const CartState({this.cartItems = const [], this.activeOrder});

  /// Total price of all items in the cart.
  double get cartTotal =>
      cartItems.fold(0, (sum, item) => sum + item.lineTotal);

  /// Total number of items in the cart.
  int get cartCount => cartItems.length;

  @override
  List<Object?> get props => [cartItems, activeOrder];
}

/// Initial idle state.
class CartIdle extends CartState {
  const CartIdle({super.cartItems, super.activeOrder});
}

/// An order is being placed / fetched / updated.
class CartLoading extends CartState {
  const CartLoading({super.cartItems, super.activeOrder});
}

/// An order was placed or updated successfully.
class CartOrderSuccess extends CartState {
  final String message;
  const CartOrderSuccess({required this.message, super.cartItems, super.activeOrder});

  @override
  List<Object?> get props => [message, cartItems, activeOrder];
}

/// Orders history loaded successfully, with pagination metadata.
class CartOrdersLoaded extends CartState {
  final List<OrderModel> orders;
  final int currentPage;
  final int totalPages;
  final int totalItems;

  const CartOrdersLoaded({
    required this.orders,
    required this.currentPage,
    required this.totalPages,
    required this.totalItems,
    super.cartItems,
    super.activeOrder,
  });

  bool get hasMore => currentPage < totalPages;

  @override
  List<Object?> get props => [orders, currentPage, totalPages, totalItems, cartItems, activeOrder];
}

/// An error occurred.
class CartError extends CartState {
  final String message;
  const CartError({required this.message, super.cartItems, super.activeOrder});

  @override
  List<Object?> get props => [message, cartItems, activeOrder];
}

/// Order cancelled successfully.
class CartOrderCancelled extends CartState {
  final String message;
  const CartOrderCancelled({required this.message, super.cartItems, super.activeOrder});

  @override
  List<Object?> get props => [message, cartItems, activeOrder];
}

/// Order updated successfully.
class CartOrderUpdated extends CartState {
  final String message;
  final OrderModel order;
  const CartOrderUpdated({
    required this.message,
    required this.order,
    super.cartItems,
    super.activeOrder,
  });

  @override
  List<Object?> get props => [message, order, cartItems, activeOrder];
}
