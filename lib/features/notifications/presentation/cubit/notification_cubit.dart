import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/locale/locale_cubit.dart';
import '../../../../core/services/push_notification_service.dart';
import '../../data/models/notification_model.dart';
import '../../data/repositories/notification_repository.dart';
import 'notification_state.dart';

/// Manages notification state and polling for new notifications.
class NotificationCubit extends Cubit<NotificationState> {
  final NotificationRepository _repository;
  final LocalNotificationService? _localNotificationService;
  Timer? _pollingTimer;

  /// Tracks the last known unread count to detect new notifications.
  int _lastKnownUnreadCount = 0;

  NotificationCubit(
    this._repository, [
    this._localNotificationService,
  ]) : super(const NotificationInitial());

  /// Start periodic polling for unread count (every 30 seconds).
  void startPolling() {
    // Fetch immediately
    fetchUnreadCount();

    _pollingTimer?.cancel();
    _pollingTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      fetchUnreadCount();
    });
  }

  /// Stop polling.
  void stopPolling() {
    _pollingTimer?.cancel();
    _pollingTimer = null;
  }

  /// Fetch only the unread count (lightweight, used by badge).
  /// If the count increased since last check, show a local notification.
  Future<void> fetchUnreadCount() async {
    try {
      final count = await _repository.getUnreadCount();
      final currentState = state;

      // Show a local notification if new unread notifications appeared
      if (count > _lastKnownUnreadCount && _lastKnownUnreadCount >= 0) {
        final newCount = count - _lastKnownUnreadCount;
        final body = _getLocalizedNotificationBody(newCount);
        _localNotificationService?.show(
          title: 'Grossist Bouchentouf',
          body: body,
        );
      }
      _lastKnownUnreadCount = count;

      if (currentState is NotificationLoaded) {
        emit(currentState.copyWith(unreadCount: count));
      } else {
        emit(NotificationLoaded(
          notifications: const [],
          unreadCount: count,
        ));
      }
    } catch (_) {
      // Silently fail — badge just won't update
    }
  }

  /// Fetch the full notification list.
  Future<void> loadNotifications({int page = 1}) async {
    if (page == 1) emit(const NotificationLoading());

    try {
      final result = await _repository.getMyNotifications(page: page);
      final count = await _repository.getUnreadCount();

      final currentState = state;
      final existingNotifications =
          (page > 1 && currentState is NotificationLoaded)
              ? currentState.notifications
              : <dynamic>[];

      emit(NotificationLoaded(
        notifications: [...existingNotifications, ...result.notifications],
        unreadCount: count,
        currentPage: result.currentPage,
        totalPages: result.totalPages,
      ));
    } on ServerException catch (e) {
      emit(NotificationError(e.message));
    } catch (_) {
      emit(const NotificationError('Failed to load notifications.'));
    }
  }

  /// Mark a single notification as read.
  Future<void> markAsRead(String notificationId) async {
    try {
      await _repository.markAsRead(notificationId);
      final currentState = state;
      if (currentState is NotificationLoaded) {
        final updated = currentState.notifications.map((n) {
          if (n.id == notificationId) {
            return NotificationModel(
              id: n.id,
              userId: n.userId,
              orderId: n.orderId,
              title: n.title,
              message: n.message,
              type: n.type,
              isRead: true,
              createdAt: n.createdAt,
            );
          }
          return n;
        }).toList();

        emit(currentState.copyWith(
          notifications: updated,
          unreadCount: (currentState.unreadCount - 1).clamp(0, 999),
        ));
      }
    } catch (_) {
      // Silently fail
    }
  }

  /// Mark all notifications as read.
  Future<void> markAllAsRead() async {
    try {
      await _repository.markAllAsRead();
      final currentState = state;
      if (currentState is NotificationLoaded) {
        final updated = currentState.notifications
            .map((n) => NotificationModel(
                  id: n.id,
                  userId: n.userId,
                  orderId: n.orderId,
                  title: n.title,
                  message: n.message,
                  type: n.type,
                  isRead: true,
                  createdAt: n.createdAt,
                ))
            .toList();

        emit(currentState.copyWith(
          notifications: updated,
          unreadCount: 0,
        ));
      }
    } catch (_) {
      // Silently fail
    }
  }

  /// Returns a localized notification body based on the current app language.
  String _getLocalizedNotificationBody(int count) {
    final lang = sl<LocaleCubit>().locale.languageCode;
    if (count == 1) {
      switch (lang) {
        case 'ar':
          return 'لديك إشعار جديد';
        case 'fr':
          return 'Vous avez une nouvelle notification';
        default:
          return 'You have a new notification';
      }
    } else {
      switch (lang) {
        case 'ar':
          return 'لديك $count إشعارات جديدة';
        case 'fr':
          return 'Vous avez $count nouvelles notifications';
        default:
          return 'You have $count new notifications';
      }
    }
  }

  @override
  Future<void> close() {
    stopPolling();
    return super.close();
  }
}
