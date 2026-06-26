import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// Lightweight service for showing local system notifications.
/// No Firebase needed — triggered by the existing polling mechanism
/// when new notifications are detected from the backend.
class LocalNotificationService {
  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  /// Callback invoked when the user taps on a notification.
  void Function()? onNotificationTapped;

  /// Whether the service has been initialized.
  bool _initialized = false;

  /// Initialize the local notification plugin and create the channel.
  Future<void> initialize() async {
    if (_initialized) return;

    // Android notification channel
    const androidChannel = AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      description: 'This channel is used for important notifications.',
      importance: Importance.high,
      playSound: true,
    );

    // Create the channel on Android
    await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(androidChannel);

    // Request notification permission (Android 13+)
    await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();

    // Initialize settings
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const initSettings = InitializationSettings(
      android: androidSettings,
    );

    await _plugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onTapped,
    );

    _initialized = true;
    debugPrint('🔔 LocalNotificationService initialized');
  }

  /// Show a local notification with the given [title] and [body].
  Future<void> show({
    required String title,
    required String body,
    int? id,
  }) async {
    if (!_initialized) return;

    await _plugin.show(
      id ?? DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      body,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'high_importance_channel',
          'High Importance Notifications',
          channelDescription:
              'This channel is used for important notifications.',
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
          playSound: true,
        ),
      ),
    );
  }

  /// Handle notification tap.
  void _onTapped(NotificationResponse response) {
    debugPrint('🔔 Notification tapped');
    onNotificationTapped?.call();
  }

  /// Clean up (call on logout).
  void dispose() {
    onNotificationTapped = null;
  }
}
