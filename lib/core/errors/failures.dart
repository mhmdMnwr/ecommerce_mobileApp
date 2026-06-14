/// Base class for failures in the application.
///
/// All feature-specific failures should extend this class.
abstract class Failure {
  final String message;
  const Failure(this.message);

  @override
  String toString() => 'Failure: $message';
}

/// A server-side failure (e.g., HTTP 500).
class ServerFailure extends Failure {
  const ServerFailure([super.message = 'Server error occurred']);
}

/// A failure caused by no network connectivity.
class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'No internet connection']);
}

/// A failure from local cache/storage operations.
class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Cache error occurred']);
}

/// A failure for unauthorized access (e.g., expired token).
class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure([super.message = 'Unauthorized access']);
}
