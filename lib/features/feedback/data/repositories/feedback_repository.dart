import '../data_sources/feedback_remote_data_source.dart';

/// Repository for feedback operations.
class FeedbackRepository {
  final FeedbackRemoteDataSource _remoteDataSource;

  FeedbackRepository(this._remoteDataSource);

  Future<void> submitFeedback(String comment) =>
      _remoteDataSource.submitFeedback(comment);
}
