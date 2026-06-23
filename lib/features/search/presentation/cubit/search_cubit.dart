import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../home/data/models/category_model.dart';
import '../../../home/data/repositories/home_repository.dart';
import '../../data/repositories/search_repository.dart';
import 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  final SearchRepository _searchRepo;
  final HomeRepository _homeRepo;

  List<CategoryModel> _categories = [];

  SearchCubit(this._searchRepo, this._homeRepo)
      : super(const SearchInitial());

  /// Load categories for the filter sheet.
  Future<void> loadCategories() async {
    try {
      _categories = await _homeRepo.getCategories();
      final s = state;
      if (s is SearchInitial) {
        emit(SearchInitial(categories: _categories));
      } else if (s is SearchLoaded) {
        emit(SearchLoaded(
          query: s.query,
          filters: s.filters,
          products: s.products,
          totalItems: s.totalItems,
          totalPages: s.totalPages,
          currentPage: s.currentPage,
          categories: _categories,
        ));
      }
    } catch (_) {
      // Categories are optional — don't block.
    }
  }

  /// Run a search with the given query and filters.
  Future<void> search(String query, {SearchFilters? filters}) async {
    final f = filters ?? const SearchFilters();
    emit(SearchLoading(query: query, filters: f));

    try {
      final result = await _searchRepo.searchProducts(
        query: query.isEmpty ? null : query,
        categoryId: f.categoryId,
        brandTitle: f.brandTitle,
        minPrice: f.minPrice,
        maxPrice: f.maxPrice,
        sort: f.sort,
      );

      emit(SearchLoaded(
        query: query,
        filters: f,
        products: result.products,
        totalItems: result.totalItems,
        totalPages: result.totalPages,
        currentPage: result.currentPage,
        categories: _categories,
      ));
    } on ServerException catch (e) {
      emit(SearchError(message: e.message, query: query, filters: f));
    } catch (_) {
      emit(SearchError(
        message: 'Search failed',
        query: query,
        filters: f,
      ));
    }
  }

  /// Load the next page (append).
  Future<void> loadMore() async {
    final s = state;
    if (s is! SearchLoaded || !s.hasMore) return;

    try {
      final result = await _searchRepo.searchProducts(
        query: s.query.isEmpty ? null : s.query,
        categoryId: s.filters.categoryId,
        brandTitle: s.filters.brandTitle,
        minPrice: s.filters.minPrice,
        maxPrice: s.filters.maxPrice,
        sort: s.filters.sort,
        page: s.currentPage + 1,
      );

      emit(SearchLoaded(
        query: s.query,
        filters: s.filters,
        products: [...s.products, ...result.products],
        totalItems: result.totalItems,
        totalPages: result.totalPages,
        currentPage: result.currentPage,
        categories: _categories,
      ));
    } catch (_) {
      // Silently fail — user can try scrolling again.
    }
  }
}
