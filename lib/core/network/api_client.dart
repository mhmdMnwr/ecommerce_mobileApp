import 'package:dio/dio.dart';

import '../storage/token_storage.dart';
import 'auth_interceptor.dart';

/// Configured [Dio] HTTP client for API communication.
///
/// Includes the [AuthInterceptor] for automatic JWT management.
class ApiClient {
  late final Dio dio;

  ApiClient({
    required String baseUrl,
    required TokenStorage tokenStorage,
    void Function()? onForceLogout,
  }) {
    dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Auth interceptor — handles token injection & silent refresh
    dio.interceptors.add(
      AuthInterceptor(
        tokenStorage: tokenStorage,
        baseUrl: baseUrl,
        onForceLogout: onForceLogout,
      ),
    );
  }
}
