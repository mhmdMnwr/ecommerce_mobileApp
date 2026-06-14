import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/errors/exceptions.dart';
import '../../data/repositories/auth_repository.dart';
import 'auth_state.dart';

/// Manages the authentication state for the entire app.
class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _repository;

  AuthCubit(this._repository) : super(const AuthInitial());

  /// Called at app startup to determine whether the user is
  /// already logged in (valid token) or needs to authenticate.
  Future<void> checkAuthStatus() async {
    emit(const AuthLoading());
    try {
      final user = await _repository.checkAuthStatus();
      if (user != null) {
        emit(AuthAuthenticated(user));
      } else {
        emit(const AuthUnauthenticated());
      }
    } catch (_) {
      emit(const AuthUnauthenticated());
    }
  }

  /// Authenticates with [username] and [password].
  Future<void> login({
    required String username,
    required String password,
  }) async {
    emit(const AuthLoading());
    try {
      final user = await _repository.login(
        username: username,
        password: password,
      );
      emit(AuthAuthenticated(user));
    } on ServerException catch (e) {
      emit(AuthError(e.message));
    } catch (_) {
      emit(const AuthError('Login failed. Please try again.'));
    }
  }

  /// Creates a new customer account.
  Future<void> register({
    required String username,
    required String password,
    required String phone,
    String? address,
    double? latitude,
    double? longitude,
  }) async {
    emit(const AuthLoading());
    try {
      await _repository.register(
        username: username,
        password: password,
        phone: phone,
        address: address,
        latitude: latitude,
        longitude: longitude,
      );
      emit(const AuthRegistrationSuccess());
    } on ServerException catch (e) {
      emit(AuthError(e.message));
    } catch (_) {
      emit(const AuthError('Registration failed. Please try again.'));
    }
  }

  /// Updates profile fields.
  Future<void> updateProfile({
    String? username,
    String? address,
    String? phone,
    double? latitude,
    double? longitude,
  }) async {
    emit(const AuthLoading());
    try {
      final user = await _repository.updateProfile(
        username: username,
        address: address,
        phone: phone,
        latitude: latitude,
        longitude: longitude,
      );
      emit(AuthAuthenticated(user));
    } on ServerException catch (e) {
      emit(AuthError(e.message));
    } catch (_) {
      emit(const AuthError('Profile update failed.'));
    }
  }

  /// Logs the user out and clears persisted tokens.
  Future<void> logout() async {
    await _repository.logout();
    emit(const AuthUnauthenticated());
  }
}
