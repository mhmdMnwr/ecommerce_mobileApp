import 'package:dio/dio.dart';

import '../../../../core/errors/exceptions.dart';
import '../models/order_model.dart';

/// Handles all order-related API calls.
class OrderRemoteDataSource {
  final Dio _dio;

  OrderRemoteDataSource(this._dio);

  /// POST /orders — Create a new order.
  Future<OrderModel> createOrder({
    required List<Map<String, dynamic>> items,
    String? comment,
  }) async {
    try {
      final body = <String, dynamic>{
        'items': items,
        if (comment != null && comment.isNotEmpty) 'comment': comment,
      };
      final response = await _dio.post('/orders', data: body);
      return OrderModel.fromJson(response.data['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _mapDioError(e);
    }
  }

  /// GET /orders/my-orders — Fetch current user's orders.
  Future<List<OrderModel>> getMyOrders({int page = 1, int limit = 20}) async {
    try {
      final response = await _dio.get(
        '/orders/my-orders',
        queryParameters: {'page': page, 'limit': limit},
      );
      final List data = response.data['data'] as List;
      return data
          .map((json) => OrderModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw _mapDioError(e);
    }
  }

  /// PATCH /orders/updateMyOrder/:orderId — Update a pending order.
  Future<OrderModel> updateMyOrder({
    required String orderId,
    required List<Map<String, dynamic>> items,
  }) async {
    try {
      final response = await _dio.patch(
        '/orders/updateMyOrder/$orderId',
        data: {'items': items},
      );
      return OrderModel.fromJson(response.data['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _mapDioError(e);
    }
  }

  /// PATCH /orders/cancelMyOrder/:orderId — Cancel a pending order.
  Future<void> cancelMyOrder(String orderId) async {
    try {
      await _dio.patch('/orders/cancelMyOrder/$orderId');
    } on DioException catch (e) {
      throw _mapDioError(e);
    }
  }

  ServerException _mapDioError(DioException e) {
    final data = e.response?.data;
    String message = 'Something went wrong';
    if (data is Map<String, dynamic>) {
      message = (data['message'] ?? data['error'] ?? message) as String;
    }
    return ServerException(message, e.response?.statusCode);
  }
}
