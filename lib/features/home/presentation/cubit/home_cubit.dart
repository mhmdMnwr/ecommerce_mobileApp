import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/errors/exceptions.dart';
import '../../data/repositories/home_repository.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final HomeRepository _repository;

  HomeCubit(this._repository) : super(const HomeInitial());

  Future<void> loadHomeData() async {
    emit(const HomeLoading());
    try {
      final categories = await _repository.getCategories();
      final newProducts = await _repository.getNewProducts();
      final popularProducts = await _repository.getPopularProducts();

      emit(HomeLoaded(
        categories: categories,
        newProducts: newProducts,
        popularProducts: popularProducts,
      ));
    } on ServerException catch (e) {
      emit(HomeError(e.message));
    } catch (_) {
      emit(const HomeError('Failed to load data.'));
    }
  }
}
