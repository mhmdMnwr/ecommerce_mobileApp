import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/errors/exceptions.dart';
import '../../data/repositories/feedback_repository.dart';
import 'feedback_state.dart';

class FeedbackCubit extends Cubit<FeedbackState> {
  final FeedbackRepository _repository;

  FeedbackCubit(this._repository) : super(const FeedbackInitial());

  Future<void> submitFeedback(String comment) async {
    emit(const FeedbackSubmitting());
    try {
      await _repository.submitFeedback(comment);
      emit(const FeedbackSuccess());
    } on ServerException catch (e) {
      emit(FeedbackError(e.message));
    } catch (_) {
      emit(const FeedbackError('Failed to submit feedback.'));
    }
  }

  void reset() => emit(const FeedbackInitial());
}
