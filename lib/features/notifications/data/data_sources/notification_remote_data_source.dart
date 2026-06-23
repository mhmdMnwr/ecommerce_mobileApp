import 'package:dio/dio.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/utils/api_constants.dart';
import '../models/notification_model.dart';

/// Pagination wrapper for notifications.
class NotificationsPage {
  final List<NotificationModel> notifications;
  final int currentPage;
  final int totalPages;
  final int totalItems;

  const NotificationsPage({
    required this.notifications,
    required this.currentPage,
    required this.totalPages,
    required this.totalItems,
  });
}

/// Handles all notification-related API calls.
class NotificationRemoteDataSource {
  final Dio _dio;

  NotificationRemoteDataSource(this._dio);

  /// GET /notifications — Fetch current user's notifications.
  Future<NotificationsPage> getMyNotifications({int page = 1, int limit = 20}) async {
    try {
      final response = await _dio.get(
        ApiConstants.notifications,
        queryParameters: {'page': page, 'limit': limit},
      );
      final List data = response.data['data'] as List;
      final pagination = response.data['meta'] as Map<String, dynamic>? ?? {};

      final notifications = data
          .map((json) => NotificationModel.fromJson(json as Map<String, dynamic>))
          .toList();

      return NotificationsPage(
        notifications: notifications,
        currentPage: (pagination['page'] as num?)?.toInt() ?? page,
        totalPages: (pagination['totalPages'] as num?)?.toInt() ?? 1,
        totalItems: (pagination['totalItems'] as num?)?.toInt() ?? notifications.length,
      );
    } on DioException catch (e) {
      throw _mapDioError(e);
    }
  }

  /// GET /notifications/unread-count
  Future<int> getUnreadCount() async {
    try {
      final response = await _dio.get(ApiConstants.unreadNotificationsCount);
      final data = response.data['data'] as Map<String, dynamic>;
      return (data['count'] as num).toInt();
    } on DioException catch (e) {
      throw _mapDioError(e);
    }
  }

  /// PATCH /notifications/read/:notificationId
  Future<void> markAsRead(String notificationId) async {
    try {
      await _dio.patch(ApiConstants.readNotification(notificationId));
    } on DioException catch (e) {
      throw _mapDioError(e);
    }
  }

  /// PATCH /notifications/read-all
  Future<void> markAllAsRead() async {
    try {
      await _dio.patch(ApiConstants.readAllNotifications);
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
