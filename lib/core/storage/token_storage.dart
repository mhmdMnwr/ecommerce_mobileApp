import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Secure token storage powered by [FlutterSecureStorage].
///
/// Handles persisting and retrieving JWT access / refresh tokens
/// and an optional cached-user JSON blob.
class TokenStorage {
  final FlutterSecureStorage _storage;

  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _cachedUserKey = 'cached_user';

  TokenStorage({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage();

  // ── Access token ────────────────────────────────

  Future<void> saveAccessToken(String token) =>
      _storage.write(key: _accessTokenKey, value: token);

  Future<String?> getAccessToken() =>
      _storage.read(key: _accessTokenKey);

  // ── Refresh token ───────────────────────────────

  Future<void> saveRefreshToken(String token) =>
      _storage.write(key: _refreshTokenKey, value: token);

  Future<String?> getRefreshToken() =>
      _storage.read(key: _refreshTokenKey);

  // ── Cached user JSON ────────────────────────────

  Future<void> saveCachedUser(String userJson) =>
      _storage.write(key: _cachedUserKey, value: userJson);

  Future<String?> getCachedUser() =>
      _storage.read(key: _cachedUserKey);

  // ── Clear all ───────────────────────────────────

  Future<void> clearAll() async {
    await _storage.delete(key: _accessTokenKey);
    await _storage.delete(key: _refreshTokenKey);
    await _storage.delete(key: _cachedUserKey);
  }

  /// Returns `true` if an access token is persisted.
  Future<bool> hasToken() async {
    final token = await getAccessToken();
    return token != null && token.isNotEmpty;
  }
}
