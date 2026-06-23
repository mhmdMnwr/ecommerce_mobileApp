import '../data_sources/order_remote_data_source.dart';
import '../models/order_model.dart';

/// Repository for order operations.
class OrderRepository {
  final OrderRemoteDataSource _remoteDataSource;

  OrderRepository(this._remoteDataSource);

  Future<OrderModel> createOrder({
    required List<Map<String, dynamic>> items,
    String? comment,
  }) =>
      _remoteDataSource.createOrder(items: items, comment: comment);

  Future<OrdersPage> getMyOrders({int page = 1, int limit = 10}) =>
      _remoteDataSource.getMyOrders(page: page, limit: limit);

  Future<OrderModel> updateMyOrder({
    required String orderId,
    required List<Map<String, dynamic>> items,
    String? comment,
  }) =>
      _remoteDataSource.updateMyOrder(orderId: orderId, items: items, comment: comment);

  Future<void> cancelMyOrder(String orderId) =>
      _remoteDataSource.cancelMyOrder(orderId);
}
