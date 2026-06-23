class ApiConstants {
  // Auth
  static const String login = '/users/login';
  static const String registerCustomer = '/users/registerCustomer';
  static const String profile = '/users/me';
  static const String refreshToken = '/users/refresh-token';

  // Orders
  static const String orders = '/orders';
  static const String myOrders = '/orders/my-orders';
  static String updateMyOrder(String orderId) => '/orders/updateMyOrder/$orderId';
  static String cancelMyOrder(String orderId) => '/orders/cancelMyOrder/$orderId';

  // Categories & Products
  static const String categories = '/categories';
  static const String brands = '/brands';
  static const String products = '/products';
  static const String newProducts = '/products/new';
  static const String topProducts = '/products/top';

  // Feedback
  static const String feedbacks = '/feedbacks';

  // Notifications
  static const String notifications = '/notifications';
  static const String unreadNotificationsCount = '/notifications/unread-count';
  static String readNotification(String notificationId) => '/notifications/read/$notificationId';
  static const String readAllNotifications = '/notifications/read-all';
}
