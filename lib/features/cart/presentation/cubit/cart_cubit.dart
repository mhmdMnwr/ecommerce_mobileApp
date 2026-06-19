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
  //  All mutations MUST carry the current activeOrder forward.
  // ──────────────────────────────────────────────────────

  /// Add a product to the cart or update quantity if already present.
  void addToCart(CartItemModel item) {
    final current = List<CartItemModel>.from(state.cartItems);
    final idx = current.indexWhere((e) => e.productId == item.productId);

    if (idx >= 0) {
      current[idx] = current[idx].copyWith(
        boxes: current[idx].boxes + item.boxes,
        units: current[idx].units + item.units,
      );
    } else {
      current.add(item);
    }

    // ✅ Carry activeOrder forward so it is never lost.
    emit(CartIdle(cartItems: current, activeOrder: state.activeOrder));
  }

  /// Update the quantity (boxes or units) of a specific cart item.
  /// Passing a value of 0 for both effectively removes the item.
  void updateQuantity(String productId, {int? boxes, int? units}) {
    final current = List<CartItemModel>.from(state.cartItems);
    final idx = current.indexWhere((e) => e.productId == productId);
    if (idx < 0) return;

    final updated = current[idx].copyWith(boxes: boxes, units: units);
    if (updated.totalUnits <= 0) {
      current.removeAt(idx);
    } else {
      current[idx] = updated;
    }

    // ✅ Carry activeOrder forward.
    emit(CartIdle(cartItems: current, activeOrder: state.activeOrder));
  }

  /// Remove a specific item from the cart.
  void removeFromCart(String productId) {
    final current = List<CartItemModel>.from(state.cartItems);
    current.removeWhere((e) => e.productId == productId);
    // ✅ Carry activeOrder forward.
    emit(CartIdle(cartItems: current, activeOrder: state.activeOrder));
  }

  /// Clear the entire cart (items only – does NOT affect the active order).
  void clearCart() {
    // ✅ Carry activeOrder forward — clearing the local cart does not cancel
    //    a backend order.
    emit(CartIdle(cartItems: const [], activeOrder: state.activeOrder));
  }

  // ──────────────────────────────────────────────────────
  //  Order API Operations
  // ──────────────────────────────────────────────────────

  /// Fetch the latest order to determine if there's an active (non-terminal) order.
  Future<void> loadActiveOrder() async {
    try {
      final orders = await _orderRepository.getMyOrders(page: 1, limit: 1);
      if (orders.isNotEmpty) {
        final latest = orders.first;
        if (latest.status == 'Pending') {
          emit(CartIdle(cartItems: state.cartItems, activeOrder: latest));
          return;
        } else if (state.activeOrder?.status == 'Pending') {
          // The order was pending but is now something else (e.g. Processing).
          // Empty the cart page as requested.
          emit(CartIdle(cartItems: const [], activeOrder: null));
          return;
        }
      }
      emit(CartIdle(cartItems: state.cartItems, activeOrder: null));
    } catch (_) {
      // Silently ignore
    }
  }

  /// Place or update an order.
  ///
  /// • If there is a **Pending** active order → **update** it with the current
  ///   local cart items.
  /// • Otherwise → **create** a brand-new order from the local cart items.
  ///
  /// The local cart items are always the source of truth; the backend order
  /// items are never used as input.
  Future<void> placeOrder({String? comment}) async {
    // Capture snapshots before any emit changes the state reference.
    final cartItems = state.cartItems;
    final activeOrder = state.activeOrder;

    if (cartItems.isEmpty) return;

    emit(CartLoading(cartItems: cartItems, activeOrder: activeOrder));

    try {
      final payload = cartItems.map((e) => e.toOrderPayload()).toList();

      if (activeOrder != null && activeOrder.isPending) {
        // Update the existing pending order with CART items.
        final updated = await _orderRepository.updateMyOrder(
          orderId: activeOrder.id,
          items: payload,
        );
        if (updated.status != 'Pending') {
          emit(CartOrderSuccess(message: 'orderUpdatedSuccess', cartItems: const [], activeOrder: null));
          emit(const CartIdle(cartItems: [], activeOrder: null));
        } else {
          emit(CartOrderSuccess(message: 'orderUpdatedSuccess', cartItems: cartItems, activeOrder: updated));
          emit(CartIdle(cartItems: cartItems, activeOrder: updated));
        }
      } else {
        // Create a brand-new order.
        final order = await _orderRepository.createOrder(
          items: payload,
          comment: comment,
        );
        if (order.status != 'Pending') {
          emit(CartOrderSuccess(message: 'orderRegisteredSuccess', cartItems: const [], activeOrder: null));
          emit(const CartIdle(cartItems: [], activeOrder: null));
        } else {
          emit(CartOrderSuccess(message: 'orderRegisteredSuccess', cartItems: cartItems, activeOrder: order));
          emit(CartIdle(cartItems: cartItems, activeOrder: order));
        }
      }
    } on ServerException catch (e) {
      emit(CartError(
        message: e.message,
        cartItems: cartItems,
        activeOrder: activeOrder,
      ));
    } catch (_) {
      emit(CartError(
        message: 'orderFailed',
        cartItems: cartItems,
        activeOrder: activeOrder,
      ));
    }
  }

  /// Fetch the user's full order history.
  Future<void> loadMyOrders({int page = 1}) async {
    final cartItems = state.cartItems;
    final activeOrder = state.activeOrder;
    emit(CartLoading(cartItems: cartItems, activeOrder: activeOrder));

    try {
      final orders = await _orderRepository.getMyOrders(page: page);
      emit(CartOrdersLoaded(
        orders: orders,
        cartItems: cartItems,
        activeOrder: activeOrder,
      ));
    } on ServerException catch (e) {
      emit(CartError(
        message: e.message,
        cartItems: cartItems,
        activeOrder: activeOrder,
      ));
    } catch (_) {
      emit(CartError(
        message: 'ordersFailed',
        cartItems: cartItems,
        activeOrder: activeOrder,
      ));
    }
  }

  /// Cancel a pending order.
  Future<void> cancelOrder(String orderId) async {
    final cartItems = state.cartItems;
    final activeOrder = state.activeOrder;
    emit(CartLoading(cartItems: cartItems, activeOrder: activeOrder));

    try {
      await _orderRepository.cancelMyOrder(orderId);
      // If the cancelled order was the active one, clear it.
      final newActive = activeOrder?.id == orderId ? null : activeOrder;
      emit(CartOrderCancelled(
        message: 'orderCancelledSuccess',
        cartItems: cartItems,
        activeOrder: newActive,
      ));
      emit(CartIdle(cartItems: cartItems, activeOrder: newActive));
    } on ServerException catch (e) {
      emit(CartError(
        message: e.message,
        cartItems: cartItems,
        activeOrder: activeOrder,
      ));
    } catch (_) {
      emit(CartError(
        message: 'cancelFailed',
        cartItems: cartItems,
        activeOrder: activeOrder,
      ));
    }
  }
}
