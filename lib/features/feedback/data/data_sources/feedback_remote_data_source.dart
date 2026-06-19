import 'package:dio/dio.dart';

import '../../../../core/errors/exceptions.dart';

/// Handles feedback-related API calls.
class FeedbackRemoteDataSource {
  final Dio _dio;

  FeedbackRemoteDataSource(this._dio);

  /// POST /feedbacks — Submit feedback.
  Future<void> submitFeedback(String comment) async {
    try {
      await _dio.post('/feedbacks', data: {'comment': comment});
    } on DioException catch (e) {
      throw _mapDioError(e);
    }
  }

  ServerException _mapDioError(DioException e) {
    final data = e.response?.data;
    String message = 'Something went wrong';
    if (data is Map<String, dynamic>) {
      message = (data['message'] ?? data['error'] ?? message) as String;
    }
    return ServerException(message, e.response?.statusCode);
  }
}
