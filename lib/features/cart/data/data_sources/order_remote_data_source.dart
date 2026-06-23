import 'package:dio/dio.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/utils/api_constants.dart';
import '../models/order_model.dart';

/// Pagination wrapper returned by [getMyOrders].
class OrdersPage {
  final List<OrderModel> orders;
  final int currentPage;
  final int totalPages;
  final int totalItems;

  const OrdersPage({
    required this.orders,
    required this.currentPage,
    required this.totalPages,
    required this.totalItems,
  });
}

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
      final response = await _dio.post(ApiConstants.orders, data: body);
      return OrderModel.fromJson(response.data['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _mapDioError(e);
    }
  }

  /// GET /orders/my-orders — Fetch current user's orders with pagination.
  Future<OrdersPage> getMyOrders({int page = 1, int limit = 10}) async {
    try {
      final response = await _dio.get(
        ApiConstants.myOrders,
        queryParameters: {'page': page, 'limit': limit},
      );
      final List data = response.data['data'] as List;
      final pagination = response.data['pagination'] as Map<String, dynamic>? ?? {};

      final orders = data
          .map((json) {
            print('DEBUG ORDER JSON: $json');
            return OrderModel.fromJson(json as Map<String, dynamic>);
          })
          .toList();

      return OrdersPage(
        orders: orders,
        currentPage: (pagination['page'] as num?)?.toInt() ?? page,
        totalPages: (pagination['totalPages'] as num?)?.toInt() ?? 1,
        totalItems: (pagination['totalItems'] as num?)?.toInt() ?? orders.length,
      );
    } on DioException catch (e) {
      throw _mapDioError(e);
    }
  }

  /// PATCH /orders/updateMyOrder/:orderId — Update a pending order.
  Future<OrderModel> updateMyOrder({
    required String orderId,
    required List<Map<String, dynamic>> items,
    String? comment,
  }) async {
    try {
      final body = <String, dynamic>{
        'items': items,
        if (comment != null) 'comment': comment,
      };
      final response = await _dio.patch(
        ApiConstants.updateMyOrder(orderId),
        data: body,
      );
      return OrderModel.fromJson(response.data['data'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _mapDioError(e);
    }
  }

  /// PATCH /orders/cancelMyOrder/:orderId — Cancel a pending order.
  Future<void> cancelMyOrder(String orderId) async {
    try {
      await _dio.patch(ApiConstants.cancelMyOrder(orderId));
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
