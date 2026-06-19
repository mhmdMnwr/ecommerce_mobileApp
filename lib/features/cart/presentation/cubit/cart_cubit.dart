import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/errors/exceptions.dart';
import '../../data/models/cart_item_model.dart';
import '../../data/repositories/order_repository.dart';
import 'cart_state.dart';

/// Manages the local shopping cart and all order-related operations.
class CartCubit extends Cubit<CartState> {
  final OrderRepository _orderRepository;

  CartCubit(this._orderRepository) : super(const CartIdle());

  // ──────────────────────────────────────────────────────
  //  Local Cart Management
  // ──────────────────────────────────────────────────────

  /// Add a product to the cart or update quantity if already present.
  void addToCart(CartItemModel item) {
    final current = List<CartItemModel>.from(state.cartItems);
    final idx = current.indexWhere((e) => e.productId == item.productId);

    if (idx >= 0) {
      // Update quantity
      current[idx] = current[idx].copyWith(
        quantity: current[idx].quantity + item.quantity,
      );
    } else {
      current.add(item);
    }

    emit(CartIdle(cartItems: current));
  }

  /// Update the quantity of a specific cart item.
  void updateQuantity(String productId, int newQuantity) {
    final current = List<CartItemModel>.from(state.cartItems);
    final idx = current.indexWhere((e) => e.productId == productId);
    if (idx < 0) return;

    if (newQuantity <= 0) {
      current.removeAt(idx);
    } else {
      current[idx] = current[idx].copyWith(quantity: newQuantity);
    }

    emit(CartIdle(cartItems: current));
  }

  /// Remove a specific item from the cart.
  void removeFromCart(String productId) {
    final current = List<CartItemModel>.from(state.cartItems);
    current.removeWhere((e) => e.productId == productId);
    emit(CartIdle(cartItems: current));
  }

  /// Clear the entire cart.
  void clearCart() {
    emit(const CartIdle());
  }

  // ──────────────────────────────────────────────────────
  //  Order API Operations
  // ──────────────────────────────────────────────────────

  /// Place a new order from the current cart contents.
  Future<void> placeOrder({String? comment}) async {
    if (state.cartItems.isEmpty) return;

    final items = state.cartItems;
    emit(CartLoading(cartItems: items));

    try {
      await _orderRepository.createOrder(
        items: items.map((e) => e.toOrderPayload()).toList(),
        comment: comment,
      );
      emit(const CartOrderSuccess(
        message: 'Your order has been registered!',
      ));
    } on ServerException catch (e) {
      emit(CartError(message: e.message, cartItems: items));
    } catch (_) {
      emit(CartError(
        message: 'Failed to place order.',
        cartItems: items,
      ));
    }
  }

  /// Fetch the user's order history.
  Future<void> loadMyOrders({int page = 1}) async {
    final items = state.cartItems;
    emit(CartLoading(cartItems: items));

    try {
      final orders = await _orderRepository.getMyOrders(page: page);
      emit(CartOrdersLoaded(orders: orders, cartItems: items));
    } on ServerException catch (e) {
      emit(CartError(message: e.message, cartItems: items));
    } catch (_) {
      emit(CartError(
        message: 'Failed to load orders.',
        cartItems: items,
      ));
    }
  }

  /// Cancel a pending order.
  Future<void> cancelOrder(String orderId) async {
    final items = state.cartItems;
    emit(CartLoading(cartItems: items));

    try {
      await _orderRepository.cancelMyOrder(orderId);
      emit(CartOrderCancelled(
        message: 'Order cancelled successfully.',
        cartItems: items,
      ));
    } on ServerException catch (e) {
      emit(CartError(message: e.message, cartItems: items));
    } catch (_) {
      emit(CartError(
        message: 'Failed to cancel order.',
        cartItems: items,
      ));
    }
  }

  /// Update a pending order's items.
  Future<void> updateOrder({
    required String orderId,
    required List<Map<String, dynamic>> items,
  }) async {
    final cartItems = state.cartItems;
    emit(CartLoading(cartItems: cartItems));

    try {
      final updated = await _orderRepository.updateMyOrder(
        orderId: orderId,
        items: items,
      );
      emit(CartOrderUpdated(
        message: 'Your order has been updated.',
        order: updated,
        cartItems: cartItems,
      ));
    } on ServerException catch (e) {
      emit(CartError(message: e.message, cartItems: cartItems));
    } catch (_) {
      emit(CartError(
        message: 'Failed to update order.',
        cartItems: cartItems,
      ));
    }
  }
}
