import 'dart:convert';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/storage/token_storage.dart';
import '../data_sources/auth_remote_data_source.dart';
import '../models/user_model.dart';

/// Orchestrates remote API calls and local token persistence
/// for everything authentication-related.
class AuthRepository {
  final AuthRemoteDataSource _remote;
  final TokenStorage _tokenStorage;

  AuthRepository({
    required AuthRemoteDataSource remote,
    required TokenStorage tokenStorage,
  })  : _remote = remote,
        _tokenStorage = tokenStorage;

  /// Full login flow: authenticate → persist tokens → fetch profile.
  /// Returns a record with the user and their account status.
  Future<({UserModel user, String status})> login({
    required String username,
    required String password,
  }) async {
    try {
      // 1. Get tokens + status
      final result = await _remote.login(
        username: username,
        password: password,
      );
      await _tokenStorage.saveAccessToken(result['accessToken']!);
      await _tokenStorage.saveRefreshToken(result['refreshToken']!);

      final status = result['status'] ?? 'active';

      // 2. Fetch & cache the user profile
      final user = await _remote.getProfile();
      await _tokenStorage.saveCachedUser(jsonEncode(user.toJson()));
      return (user: user, status: status);
    } on ServerException {
      rethrow;
    } catch (e) {
      throw const ServerException('Login failed. Please try again.');
    }
  }

  /// Register a new customer account.
  /// Saves tokens to cache and returns the account status.
  Future<String> register({
    required String username,
    required String password,
    required String phone,
    String? address,
    double? latitude,
    double? longitude,
  }) async {
    try {
      final result = await _remote.register(
        username: username,
        password: password,
        phone: phone,
        address: address,
        latitude: latitude,
        longitude: longitude,
      );

      // Save tokens so the session is cached
      await _tokenStorage.saveAccessToken(result['accessToken']!);
      await _tokenStorage.saveRefreshToken(result['refreshToken']!);

      return result['status'] ?? 'inactive';
    } on ServerException {
      rethrow;
    } catch (e) {
      throw const ServerException('Registration failed. Please try again.');
    }
  }

  /// Checks whether the user has a valid session.
  ///
  /// Returns the [UserModel] if the saved access token is still valid,
  /// `null` otherwise (the [AuthInterceptor] will attempt a silent
  /// refresh automatically on 401).
  Future<UserModel?> checkAuthStatus() async {
    final hasToken = await _tokenStorage.hasToken();
    if (!hasToken) return null;

    try {
      final user = await _remote.getProfile();
      await _tokenStorage.saveCachedUser(jsonEncode(user.toJson()));
      return user;
    } on ServerException catch (e) {
      // If we get a 401 even after the interceptor tried to refresh,
      // the session is truly dead.
      if (e.statusCode == 401) {
        await _tokenStorage.clearAll();
        return null;
      }
      // For other server errors, try returning cached user
      return _getCachedUser();
    } catch (_) {
      return _getCachedUser();
    }
  }

  /// Fetches the current user's profile.
  Future<UserModel> getProfile() async {
    try {
      final user = await _remote.getProfile();
      await _tokenStorage.saveCachedUser(jsonEncode(user.toJson()));
      return user;
    } on ServerException {
      rethrow;
    }
  }

  /// Updates the user's profile.
  Future<UserModel> updateProfile({
    String? username,
    String? address,
    String? phone,
    double? latitude,
    double? longitude,
  }) async {
    try {
      final user = await _remote.updateProfile(
        username: username,
        address: address,
        phone: phone,
        latitude: latitude,
        longitude: longitude,
      );
      await _tokenStorage.saveCachedUser(jsonEncode(user.toJson()));
      return user;
    } on ServerException {
      rethrow;
    }
  }

  /// Clears all persisted auth data.
  Future<void> logout() async {
    await _tokenStorage.clearAll();
  }

  // ── Private helpers ─────────────────────────────

  Future<UserModel?> _getCachedUser() async {
    final json = await _tokenStorage.getCachedUser();
    if (json == null) return null;
    try {
      return UserModel.fromJson(
        jsonDecode(json) as Map<String, dynamic>,
      );
    } catch (_) {
      return null;
    }
  }
}
