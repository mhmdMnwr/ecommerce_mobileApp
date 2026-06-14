import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../storage/token_storage.dart';
import 'auth_interceptor.dart';

/// Configured [Dio] HTTP client for API communication.
///
/// Includes the [AuthInterceptor] for automatic JWT management
/// and a [LogInterceptor] for debugging.
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

    // Log interceptor — prints request/response details in debug mode
    if (kDebugMode) {
      dio.interceptors.add(
        LogInterceptor(
          requestBody: true,
          responseBody: true,
          requestHeader: false,
          responseHeader: false,
          error: true,
          logPrint: (obj) => debugPrint(obj.toString()),
        ),
      );
    }
  }
}
