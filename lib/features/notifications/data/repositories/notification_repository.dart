import '../data_sources/notification_remote_data_source.dart';

/// Repository for notification operations.
class NotificationRepository {
  final NotificationRemoteDataSource _remoteDataSource;

  NotificationRepository(this._remoteDataSource);

  Future<NotificationsPage> getMyNotifications({int page = 1, int limit = 20}) =>
      _remoteDataSource.getMyNotifications(page: page, limit: limit);

  Future<int> getUnreadCount() => _remoteDataSource.getUnreadCount();

  Future<void> markAsRead(String notificationId) =>
      _remoteDataSource.markAsRead(notificationId);

  Future<void> markAllAsRead() => _remoteDataSource.markAllAsRead();
}
