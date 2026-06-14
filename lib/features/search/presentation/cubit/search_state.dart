import '../../../home/data/models/category_model.dart';
import '../../../home/data/models/product_model.dart';

/// Holds the active search filters.
class SearchFilters {
  final String? categoryId;
  final String? categoryName;
  final double? minPrice;
  final double? maxPrice;
  final String? sort;

  const SearchFilters({
    this.categoryId,
    this.categoryName,
    this.minPrice,
    this.maxPrice,
    this.sort,
  });

  SearchFilters copyWith({
    String? categoryId,
    String? categoryName,
    double? minPrice,
    double? maxPrice,
    String? sort,
    bool clearCategory = false,
    bool clearPrice = false,
  }) {
    return SearchFilters(
      categoryId: clearCategory ? null : (categoryId ?? this.categoryId),
      categoryName:
          clearCategory ? null : (categoryName ?? this.categoryName),
      minPrice: clearPrice ? null : (minPrice ?? this.minPrice),
      maxPrice: clearPrice ? null : (maxPrice ?? this.maxPrice),
      sort: sort ?? this.sort,
    );
  }

  bool get hasActiveFilters =>
      categoryId != null || minPrice != null || maxPrice != null;
}

/// All possible search states.
abstract class SearchState {
  const SearchState();
}

class SearchInitial extends SearchState {
  final List<CategoryModel> categories;
  const SearchInitial({this.categories = const []});
}

class SearchLoading extends SearchState {
  final String query;
  final SearchFilters filters;
  const SearchLoading({required this.query, required this.filters});
}

class SearchLoaded extends SearchState {
  final String query;
  final SearchFilters filters;
  final List<ProductModel> products;
  final int totalItems;
  final int totalPages;
  final int currentPage;
  final List<CategoryModel> categories;

  const SearchLoaded({
    required this.query,
    required this.filters,
    required this.products,
    required this.totalItems,
    required this.totalPages,
    required this.currentPage,
    required this.categories,
  });

  bool get hasMore => currentPage < totalPages;
}

class SearchError extends SearchState {
  final String message;
  final String query;
  final SearchFilters filters;

  const SearchError({
    required this.message,
    required this.query,
    required this.filters,
  });
}
