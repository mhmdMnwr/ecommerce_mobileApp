import 'package:dio/dio.dart';

import '../storage/token_storage.dart';

/// Dio interceptor that handles JWT authentication transparently.
///
/// • Attaches `Authorization: Bearer <token>` to every authenticated request.
/// • On a 401 response, attempts a silent token refresh and retries.
/// • Uses [QueuedInterceptor] so concurrent 401s don't trigger multiple refreshes.
class AuthInterceptor extends QueuedInterceptor {
  final TokenStorage _tokenStorage;
  final Dio _refreshDio; // plain Dio – avoids interceptor recursion
  final void Function()? onForceLogout;

  /// Endpoints that must NOT carry an auth header.
  static const _publicPaths = [
    '/users/login',
    '/users/registerCustomer',
    '/users/refresh-token',
  ];

  AuthInterceptor({
    required TokenStorage tokenStorage,
    required String baseUrl,
    this.onForceLogout,
  })  : _tokenStorage = tokenStorage,
        _refreshDio = Dio(BaseOptions(
          baseUrl: baseUrl,
          connectTimeout: const Duration(seconds: 15),
          receiveTimeout: const Duration(seconds: 15),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ));

  bool _isPublic(String path) =>
      _publicPaths.any((p) => path.contains(p));

  // ── Attach token to every non-public request ────────────────

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (!_isPublic(options.path)) {
      final token = await _tokenStorage.getAccessToken();
      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    }
    handler.next(options);
  }

  // ── Handle 401 → refresh → retry ───────────────────────────

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode != 401 ||
        _isPublic(err.requestOptions.path)) {
      return handler.next(err);
    }

    // Attempt a silent refresh
    final refreshToken = await _tokenStorage.getRefreshToken();
    if (refreshToken == null || refreshToken.isEmpty) {
      await _tokenStorage.clearAll();
      onForceLogout?.call();
      return handler.next(err);
    }

    try {
      final res = await _refreshDio.post(
        '/users/refresh-token',
        data: {'token': refreshToken},
      );

      final newAccessToken =
          res.data['data']['accessToken'] as String;
      await _tokenStorage.saveAccessToken(newAccessToken);

      // Retry the original request with the fresh token
      final opts = err.requestOptions;
      opts.headers['Authorization'] = 'Bearer $newAccessToken';

      final retryResponse = await _refreshDio.fetch(opts);
      return handler.resolve(retryResponse);
    } on DioException {
      // Refresh failed – force logout
      await _tokenStorage.clearAll();
      onForceLogout?.call();
      return handler.next(err);
    }
  }
}
