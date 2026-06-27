import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/routing/app_router.dart';
import '../../../../core/services/push_notification_service.dart';
import '../../../cart/presentation/cubit/cart_cubit.dart';
import '../../../notifications/presentation/cubit/notification_cubit.dart';
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
        // Check if the user's account is still inactive
        if (user.status == 'inactive') {
          emit(const AuthPendingApproval());
        } else {
          emit(AuthAuthenticated(user));
          _initLocalNotifications();
        }
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
      final result = await _repository.login(
        username: username,
        password: password,
      );
      if (result.status != 'active') {
        emit(const AuthPendingApproval());
      } else {
        emit(AuthAuthenticated(result.user));
        _initLocalNotifications();
      }
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
      final status = await _repository.register(
        username: username,
        password: password,
        phone: phone,
        address: address,
        latitude: latitude,
        longitude: longitude,
      );
      if (status == 'active') {
        // Shouldn't happen for customers, but handle it
        final user = await _repository.getProfile();
        emit(AuthAuthenticated(user));
        _initLocalNotifications();
      } else {
        emit(const AuthPendingApproval());
      }
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
    sl<CartCubit>().reset();
    sl<NotificationCubit>().stopPolling();
    sl<LocalNotificationService>().dispose();
    emit(const AuthUnauthenticated());
  }

  /// Initialize local notification service and set tap handler.
  void _initLocalNotifications() {
    final localNotifService = sl<LocalNotificationService>();

    // When a notification is tapped, navigate to the notifications page
    localNotifService.onNotificationTapped = () {
      appRouter.push(AppRoutes.notifications);
    };

    // Initialize the local notification plugin (channel, permissions, etc.)
    localNotifService.initialize();
  }
}
