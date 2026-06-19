import 'package:equatable/equatable.dart';
import '../../data/models/notification_model.dart';

abstract class NotificationState extends Equatable {
  const NotificationState();

  @override
  List<Object?> get props => [];
}

class NotificationInitial extends NotificationState {
  const NotificationInitial();
}

class NotificationLoading extends NotificationState {
  const NotificationLoading();
}

class NotificationLoaded extends NotificationState {
  final List<NotificationModel> notifications;
  final int unreadCount;
  final int currentPage;
  final int totalPages;

  const NotificationLoaded({
    required this.notifications,
    required this.unreadCount,
    this.currentPage = 1,
    this.totalPages = 1,
  });

  @override
  List<Object?> get props => [notifications, unreadCount, currentPage, totalPages];

  NotificationLoaded copyWith({
    List<NotificationModel>? notifications,
    int? unreadCount,
    int? currentPage,
    int? totalPages,
  }) {
    return NotificationLoaded(
      notifications: notifications ?? this.notifications,
      unreadCount: unreadCount ?? this.unreadCount,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
    );
  }
}

class NotificationError extends NotificationState {
  final String message;
  const NotificationError(this.message);

  @override
  List<Object?> get props => [message];
}
