import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/errors/exceptions.dart';
import '../../data/models/cart_item_model.dart';
import '../../data/models/order_model.dart';
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

    emit(CartIdle(cartItems: current, activeOrder: state.activeOrder));
  }

  /// Update the quantity (boxes or units) of a specific cart item.
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

    emit(CartIdle(cartItems: current, activeOrder: state.activeOrder));
  }

  /// Remove a specific item from the cart.
  void removeFromCart(String productId) {
    final current = List<CartItemModel>.from(state.cartItems);
    current.removeWhere((e) => e.productId == productId);
    emit(CartIdle(cartItems: current, activeOrder: state.activeOrder));
  }

  /// Clear the entire cart (items only – does NOT affect the active order).
  void clearCart() {
    emit(CartIdle(cartItems: const [], activeOrder: state.activeOrder));
  }

  /// Reset the entire cubit state (e.g. on logout).
  void reset() {
    emit(const CartIdle(cartItems: [], activeOrder: null));
  }

  // ──────────────────────────────────────────────────────
  //  Order API Operations
  // ──────────────────────────────────────────────────────

  /// Fetch the latest order — if it is Pending, attach it as the activeOrder.
  /// If the latest order is not Pending (or none), clear the cart page.
  Future<void> loadActiveOrder() async {
    try {
      final page = await _orderRepository.getMyOrders(page: 1, limit: 1);
      if (page.orders.isNotEmpty) {
        final latest = page.orders.first;
        if (latest.status == 'Pending') {
          // If there is a pending order, populate the cart with its items so the user can edit them
          final mappedCartItems = latest.items.map((orderItem) {
            final unitsPerBox = orderItem.units > 0 ? orderItem.units : 1;
            return CartItemModel(
              productId: orderItem.productId,
              title: orderItem.title ?? 'Unknown Product',
              image: orderItem.image ?? '',
              price: orderItem.price,
              unitsPerBox: unitsPerBox,
              boxes: orderItem.quantity ~/ unitsPerBox,
              units: orderItem.quantity % unitsPerBox,
            );
          }).toList();
          
          emit(CartIdle(cartItems: mappedCartItems, activeOrder: latest));
          return;
        } else if (state.activeOrder?.status == 'Pending') {
          // Was pending before, now it's moved on — empty the cart page.
          emit(const CartIdle(cartItems: [], activeOrder: null));
          return;
        }
      }
      emit(CartIdle(cartItems: state.cartItems, activeOrder: null));
    } catch (_) {
      // Silently ignore — don't crash the cart if this fails.
    }
  }

  /// Place a new order or update the existing pending order with cart items.
  Future<void> placeOrder({String? comment}) async {
    final cartItems = state.cartItems;
    final activeOrder = state.activeOrder;

    if (cartItems.isEmpty) return;

    emit(CartLoading(cartItems: cartItems, activeOrder: activeOrder));

    try {
      final payload = cartItems.map((e) => e.toOrderPayload()).toList();
      print('DEBUG PLACE ORDER COMMENT: $comment');
      print('DEBUG ACTIVE ORDER COMMENT: ${activeOrder?.comment}');

      if (activeOrder != null && activeOrder.isPending) {
        final updated = await _orderRepository.updateMyOrder(
          orderId: activeOrder.id,
          items: payload,
          comment: comment ?? activeOrder.comment,
        );
        if (updated.status != 'Pending') {
          emit(CartOrderSuccess(message: 'orderUpdatedSuccess', cartItems: const [], activeOrder: null));
          emit(const CartIdle(cartItems: [], activeOrder: null));
        } else {
          emit(CartOrderSuccess(message: 'orderUpdatedSuccess', cartItems: cartItems, activeOrder: updated));
          emit(CartIdle(cartItems: cartItems, activeOrder: updated));
        }
      } else {
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
      emit(CartError(message: e.message, cartItems: cartItems, activeOrder: activeOrder));
    } catch (_) {
      emit(CartError(message: 'orderFailed', cartItems: cartItems, activeOrder: activeOrder));
    }
  }

  /// Load the first page of order history.
  Future<void> loadMyOrders() async {
    final cartItems = state.cartItems;
    final activeOrder = state.activeOrder;
    emit(CartLoading(cartItems: cartItems, activeOrder: activeOrder));
    await _fetchOrdersPage(page: 1, existingOrders: const []);
  }

  /// Load an additional page and append to the existing list.
  Future<void> loadMoreOrders() async {
    final current = state;
    if (current is! CartOrdersLoaded || !current.hasMore) return;

    // Keep showing current orders while loading more.
    emit(CartOrdersLoaded(
      orders: current.orders,
      currentPage: current.currentPage,
      totalPages: current.totalPages,
      totalItems: current.totalItems,
      cartItems: current.cartItems,
      activeOrder: current.activeOrder,
    ));

    await _fetchOrdersPage(
      page: current.currentPage + 1,
      existingOrders: current.orders,
    );
  }

  Future<void> _fetchOrdersPage({
    required int page,
    required List<OrderModel> existingOrders,
  }) async {
    final cartItems = state.cartItems;
    final activeOrder = state.activeOrder;
    try {
      final result = await _orderRepository.getMyOrders(page: page, limit: 10);
      emit(CartOrdersLoaded(
        orders: [...existingOrders, ...result.orders],
        currentPage: result.currentPage,
        totalPages: result.totalPages,
        totalItems: result.totalItems,
        cartItems: cartItems,
        activeOrder: activeOrder,
      ));
    } on ServerException catch (e) {
      emit(CartError(message: e.message, cartItems: cartItems, activeOrder: activeOrder));
    } catch (_) {
      emit(CartError(message: 'ordersFailed', cartItems: cartItems, activeOrder: activeOrder));
    }
  }

  /// Cancel a pending order and refresh history if on history page.
  Future<void> cancelOrder(String orderId) async {
    final cartItems = state.cartItems;
    final activeOrder = state.activeOrder;
    emit(CartLoading(cartItems: cartItems, activeOrder: activeOrder));

    try {
      await _orderRepository.cancelMyOrder(orderId);
      final newActive = activeOrder?.id == orderId ? null : activeOrder;
      emit(CartOrderCancelled(
        message: 'orderCancelledSuccess',
        cartItems: cartItems,
        activeOrder: newActive,
      ));
      emit(CartIdle(cartItems: cartItems, activeOrder: newActive));
    } on ServerException catch (e) {
      emit(CartError(message: e.message, cartItems: cartItems, activeOrder: activeOrder));
    } catch (_) {
      emit(CartError(message: 'cancelFailed', cartItems: cartItems, activeOrder: activeOrder));
    }
  }
}
