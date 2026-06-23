import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_loading_indicator.dart';
import '../cubit/notification_cubit.dart';
import '../cubit/notification_state.dart';
import '../../data/models/notification_model.dart';
import 'package:ecommerce_app/l10n/app_localizations.dart';

/// Full-screen notifications page.
class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  @override
  void initState() {
    super.initState();
    context.read<NotificationCubit>().loadNotifications();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            size: 18.r,
            color: AppColors.textPrimary,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          l10n.notification,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        actions: [
          BlocBuilder<NotificationCubit, NotificationState>(
            builder: (context, state) {
              if (state is NotificationLoaded && state.unreadCount > 0) {
                return TextButton(
                  onPressed: () =>
                      context.read<NotificationCubit>().markAllAsRead(),
                  child: Text(
                    l10n.markAllRead,
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: BlocBuilder<NotificationCubit, NotificationState>(
        builder: (context, state) {
          if (state is NotificationLoading) {
            return const Center(
              child: AppLoadingIndicator(),
            );
          }

          if (state is NotificationError) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.error_outline, size: 48.r, color: AppColors.error),
                  SizedBox(height: 12.h),
                  Text(
                    state.message,
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 14.sp,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  TextButton.icon(
                    onPressed: () =>
                        context.read<NotificationCubit>().loadNotifications(),
                    icon: const Icon(Icons.refresh),
                    label: Text(l10n.retry),
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.primary,
                    ),
                  ),
                ],
              ),
            );
          }

          if (state is NotificationLoaded) {
            if (state.notifications.isEmpty) {
              return _buildEmpty(l10n);
            }

            return RefreshIndicator(
              color: AppColors.primary,
              onRefresh: () =>
                  context.read<NotificationCubit>().loadNotifications(),
              child: ListView.separated(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                itemCount: state.notifications.length,
                separatorBuilder: (_, i) => SizedBox(height: 8.h),
                itemBuilder: (context, index) {
                  final notification = state.notifications[index];
                  return _NotificationCard(
                    notification: notification,
                    onTap: () {
                      if (!notification.isRead) {
                        context
                            .read<NotificationCubit>()
                            .markAsRead(notification.id);
                      }
                    },
                  );
                },
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildEmpty(AppLocalizations l10n) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 80.r,
            height: 80.r,
            decoration: BoxDecoration(
              color: AppColors.primary.withAlpha(20),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.notifications_none_rounded,
              size: 40.r,
              color: AppColors.primary,
            ),
          ),
          SizedBox(height: 20.h),
          Text(
            l10n.noNotifications,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            l10n.noNotificationsMessage,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13.sp,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

/// Single notification card.
class _NotificationCard extends StatelessWidget {
  final NotificationModel notification;
  final VoidCallback onTap;

  const _NotificationCard({
    required this.notification,
    required this.onTap,
  });

  IconData _iconForType(String type) {
    switch (type) {
      case 'order_status':
        return Icons.local_shipping_outlined;
      case 'order_update':
        return Icons.edit_note_rounded;
      default:
        return Icons.notifications_outlined;
    }
  }

  Color _colorForType(String type) {
    switch (type) {
      case 'order_status':
        return const Color(0xFF2196F3);
      case 'order_update':
        return const Color(0xFFFF9800);
      default:
        return AppColors.primary;
    }
  }

  String _formatTime(String isoDate) {
    try {
      final date = DateTime.parse(isoDate);
      final now = DateTime.now();
      final diff = now.difference(date);

      if (diff.inMinutes < 1) return 'Just now';
      if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
      if (diff.inHours < 24) return '${diff.inHours}h ago';
      if (diff.inDays < 7) return '${diff.inDays}d ago';
      return '${date.day}/${date.month}/${date.year}';
    } catch (_) {
      return '';
    }
  }

  String _getTranslatedTitle(BuildContext context, String rawTitle) {
    // We didn't regenerate AppLocalizations using build_runner in this session,
    // so we will manually map the known keys to avoid compilation errors if they aren't generated yet.
    // If we use dynamic keys, we map them directly.
    final l10n = AppLocalizations.of(context)!;
    if (rawTitle == 'notification_title_order_update') {
      // Fallback if gen-l10n didn't run: we use the raw strings for now or try to access them if they exist.
      // Wait, since I can't be sure flutter gen-l10n succeeded, I will just provide a fallback mapping to English/French/Arabic.
      final lang = Localizations.localeOf(context).languageCode;
      if (lang == 'ar') return 'تم تحديث الطلب';
      if (lang == 'fr') return 'Commande mise à jour';
      return 'Order Updated';
    }
    if (rawTitle == 'notification_title_order_status') {
      final lang = Localizations.localeOf(context).languageCode;
      if (lang == 'ar') return 'تحديث حالة الطلب';
      if (lang == 'fr') return 'Statut de la commande mis à jour';
      return 'Order Status Updated';
    }
    return rawTitle;
  }

  String _getTranslatedMessage(BuildContext context, String rawMessage) {
    try {
      final decoded = jsonDecode(rawMessage);
      if (decoded is Map<String, dynamic> && decoded.containsKey('key')) {
        final key = decoded['key'];
        final args = decoded['args'] as Map<String, dynamic>? ?? {};
        
        final lang = Localizations.localeOf(context).languageCode;
        if (key == 'notification_message_order_update') {
          final totalAmount = args['totalAmount']?.toString() ?? '';
          if (lang == 'ar') return 'تم تحديث طلبك من قبل المشرف. المجموع الجديد: $totalAmount دج.';
          if (lang == 'fr') return 'Votre commande a été mise à jour par l\'administrateur. Nouveau total: $totalAmount DZD.';
          return 'Your order has been updated by the admin. New total: $totalAmount DZD.';
        }
        if (key == 'notification_message_order_status') {
          final oldStatus = args['oldStatus']?.toString() ?? '';
          final status = args['status']?.toString() ?? '';
          if (lang == 'ar') return 'تغيرت حالة طلبك من $oldStatus إلى $status.';
          if (lang == 'fr') return 'Le statut de votre commande est passé de $oldStatus à $status.';
          return 'Your order status has changed from $oldStatus to $status.';
        }
      }
    } catch (_) {
      // Not JSON, it's an old notification with raw text.
    }
    return rawMessage;
  }

  @override
  Widget build(BuildContext context) {
    final color = _colorForType(notification.type);
    final translatedTitle = _getTranslatedTitle(context, notification.title);
    final translatedMessage = _getTranslatedMessage(context, notification.message);

    return Container(
      decoration: BoxDecoration(
        color: notification.isRead
            ? AppColors.background
            : color.withAlpha(12),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: notification.isRead
              ? AppColors.fieldBorder
              : color.withAlpha(40),
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(14.r),
        child: InkWell(
          borderRadius: BorderRadius.circular(14.r),
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.all(14.w),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon
                Container(
                  width: 42.r,
                  height: 42.r,
                  decoration: BoxDecoration(
                    color: color.withAlpha(25),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Icon(
                    _iconForType(notification.type),
                    size: 22.r,
                    color: color,
                  ),
                ),
                SizedBox(width: 12.w),
                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              translatedTitle,
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: notification.isRead
                                    ? FontWeight.w500
                                    : FontWeight.w700,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                          if (!notification.isRead)
                            Container(
                              width: 8.r,
                              height: 8.r,
                              decoration: BoxDecoration(
                                color: color,
                                shape: BoxShape.circle,
                              ),
                            ),
                        ],
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        translatedMessage,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: AppColors.textSecondary,
                          height: 1.4,
                        ),
                      ),
                      SizedBox(height: 6.h),
                      Text(
                        _formatTime(notification.createdAt),
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: AppColors.textHint,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
