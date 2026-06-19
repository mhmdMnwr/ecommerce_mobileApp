import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/errors/exceptions.dart';
import '../../data/models/notification_model.dart';
import '../../data/repositories/notification_repository.dart';
import 'notification_state.dart';

/// Manages notification state and polling for new notifications.
class NotificationCubit extends Cubit<NotificationState> {
  final NotificationRepository _repository;
  Timer? _pollingTimer;

  NotificationCubit(this._repository) : super(const NotificationInitial());

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
  Future<void> fetchUnreadCount() async {
    try {
      final count = await _repository.getUnreadCount();
      final currentState = state;
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

  @override
  Future<void> close() {
    stopPolling();
    return super.close();
  }
}
