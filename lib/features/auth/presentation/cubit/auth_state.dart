import 'package:equatable/equatable.dart';

import '../../data/models/user_model.dart';

/// All possible states for the authentication flow.
abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

/// Initial state – no auth check has been performed yet.
class AuthInitial extends AuthState {
  const AuthInitial();
}

/// An auth operation (login / register / profile fetch) is in progress.
class AuthLoading extends AuthState {
  const AuthLoading();
}

/// The user is authenticated and their profile is available.
class AuthAuthenticated extends AuthState {
  final UserModel user;
  const AuthAuthenticated(this.user);

  @override
  List<Object?> get props => [user.id];
}

/// There is no valid session – the user must log in.
class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

/// Registration completed successfully.
class AuthRegistrationSuccess extends AuthState {
  final String message;
  const AuthRegistrationSuccess(
      [this.message = 'Registration successful! Please log in.']);

  @override
  List<Object?> get props => [message];
}

/// The user's account exists but is pending admin approval.
class AuthPendingApproval extends AuthState {
  const AuthPendingApproval();
}

/// An auth operation failed.
class AuthError extends AuthState {
  final String message;
  const AuthError(this.message);

  @override
  List<Object?> get props => [message];
}
