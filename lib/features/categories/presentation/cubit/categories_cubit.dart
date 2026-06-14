import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/brand_model.dart';
import '../../../home/data/models/category_model.dart';
import '../../data/repositories/categories_repository.dart';

abstract class CategoriesState extends Equatable {
  const CategoriesState();
  @override
  List<Object?> get props => [];
}

class CategoriesInitial extends CategoriesState {}
class CategoriesLoading extends CategoriesState {}

class CategoriesLoaded extends CategoriesState {
  final List<CategoryModel> categories;
  final List<BrandModel> brands;

  const CategoriesLoaded({
    required this.categories,
    required this.brands,
  });

  @override
  List<Object?> get props => [categories, brands];
}

class CategoriesError extends CategoriesState {
  final String message;
  const CategoriesError(this.message);
  @override
  List<Object?> get props => [message];
}

class CategoriesCubit extends Cubit<CategoriesState> {
  final CategoriesRepository _repository;

  CategoriesCubit(this._repository) : super(CategoriesInitial());

  Future<void> loadData() async {
    emit(CategoriesLoading());
    try {
      final categories = await _repository.getCategories();
      final brands = await _repository.getBrands();
      emit(CategoriesLoaded(categories: categories, brands: brands));
    } catch (e) {
      emit(CategoriesError(e.toString()));
    }
  }
}
