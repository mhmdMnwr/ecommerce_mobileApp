/// Base class for exceptions thrown by data sources.
abstract class AppException implements Exception {
  final String message;
  const AppException(this.message);

  @override
  String toString() => 'AppException: $message';
}

/// Thrown when a server request fails.
class ServerException extends AppException {
  final int? statusCode;
  const ServerException([super.message = 'Server error', this.statusCode]);
}

/// Thrown when there is no cached data.
class CacheException extends AppException {
  const CacheException([super.message = 'No cached data found']);
}

/// Thrown when there is no network connectivity.
class NetworkException extends AppException {
  const NetworkException([super.message = 'No internet connection']);
}
