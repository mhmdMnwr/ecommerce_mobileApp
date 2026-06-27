import 'package:dio/dio.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/utils/api_constants.dart';
import '../models/user_model.dart';

/// Handles all authentication-related API calls.
class AuthRemoteDataSource {
  final Dio _dio;

  AuthRemoteDataSource(this._dio);

  /// POST /users/login → returns `{accessToken, refreshToken, status}`.
  Future<Map<String, String>> login({
    required String username,
    required String password,
  }) async {
    try {
      final response = await _dio.post(
        ApiConstants.login,
        data: {'username': username, 'password': password},
      );
      final data = response.data['data'] as Map<String, dynamic>;
      return {
        'accessToken': data['accessToken'] as String,
        'refreshToken': data['refreshToken'] as String,
        'status': (data['status'] as String?) ?? 'active',
      };
    } on DioException catch (e) {
      throw _mapDioError(e);
    }
  }

  /// POST /users/registerCustomer → returns `{accessToken, refreshToken, status}`.
  Future<Map<String, String>> register({
    required String username,
    required String password,
    required String phone,
    String? address,
    double? latitude,
    double? longitude,
  }) async {
    try {
      final body = <String, dynamic>{
        'username': username,
        'password': password,
        'phone': phone,
      };
      if (address != null && address.isNotEmpty) body['address'] = address;
      if (latitude != null) body['latitude'] = latitude;
      if (longitude != null) body['longitude'] = longitude;

      final response = await _dio.post(
        ApiConstants.registerCustomer,
        data: body,
      );
      final data = response.data['data'] as Map<String, dynamic>;
      return {
        'accessToken': data['accessToken'] as String,
        'refreshToken': data['refreshToken'] as String,
        'status': (data['status'] as String?) ?? 'inactive',
      };
    } on DioException catch (e) {
      throw _mapDioError(e);
    }
  }

  /// GET /users/me → returns the authenticated user's profile.
  Future<UserModel> getProfile() async {
    try {
      final response = await _dio.get(ApiConstants.profile);
      return UserModel.fromJson(
        response.data['data'] as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      throw _mapDioError(e);
    }
  }

  /// PATCH /users/me → updates profile fields and returns updated [UserModel].
  Future<UserModel> updateProfile({
    String? username,
    String? address,
    String? phone,
    double? latitude,
    double? longitude,
  }) async {
    try {
      final body = <String, dynamic>{};
      if (username != null) body['username'] = username;
      if (address != null) body['address'] = address;
      if (phone != null) body['phone'] = phone;
      if (latitude != null) body['latitude'] = latitude;
      if (longitude != null) body['longitude'] = longitude;

      final response = await _dio.patch(ApiConstants.profile, data: body);
      return UserModel.fromJson(
        response.data['data'] as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      throw _mapDioError(e);
    }
  }

  // ── Helper ─────────────────────────────────────

  /// Extracts a human-readable message from a Dio error response.
  ServerException _mapDioError(DioException e) {
    final data = e.response?.data;
    String message = 'Something went wrong';
    if (data is Map<String, dynamic>) {
      message = (data['message'] ?? data['error'] ?? message) as String;
    }
    return ServerException(message, e.response?.statusCode);
  }
}
