import '../data_sources/search_remote_data_source.dart';

class SearchRepository {
  final SearchRemoteDataSource _remote;

  SearchRepository(this._remote);

  Future<SearchResult> searchProducts({
    String? query,
    String? categoryId,
    double? minPrice,
    double? maxPrice,
    String? sort,
    int page = 1,
    int limit = 20,
  }) =>
      _remote.searchProducts(
        query: query,
        categoryId: categoryId,
        minPrice: minPrice,
        maxPrice: maxPrice,
        sort: sort,
        page: page,
        limit: limit,
      );
}
