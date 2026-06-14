import 'package:dio/dio.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../home/data/models/product_model.dart';

/// Handles search API calls.
class SearchRemoteDataSource {
  final Dio _dio;

  SearchRemoteDataSource(this._dio);

  /// Searches products with the given filters.
  /// Returns a list of products and total count.
  Future<SearchResult> searchProducts({
    String? query,
    String? categoryId,
    String? brandTitle,
    double? minPrice,
    double? maxPrice,
    String? sort,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final params = <String, dynamic>{
        'page': page,
        'limit': limit,
      };

      if (query != null && query.isNotEmpty) params['title'] = query;
      if (categoryId != null) params['categoryId'] = categoryId;
      if (brandTitle != null) params['brand'] = brandTitle;
      if (minPrice != null) params['minPrice'] = minPrice;
      if (maxPrice != null) params['maxPrice'] = maxPrice;
      if (sort != null) params['sort'] = sort;

      final response = await _dio.get('/products', queryParameters: params);
      final List data = response.data['data'] as List;
      final meta = response.data['meta'] as Map<String, dynamic>?;

      final products = data
          .map((json) => ProductModel.fromJson(json as Map<String, dynamic>))
          .toList();

      return SearchResult(
        products: products,
        totalItems: meta?['totalItems'] as int? ?? products.length,
        totalPages: meta?['totalPages'] as int? ?? 1,
        currentPage: meta?['page'] as int? ?? page,
      );
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

/// Holds a page of search results plus pagination metadata.
class SearchResult {
  final List<ProductModel> products;
  final int totalItems;
  final int totalPages;
  final int currentPage;

  const SearchResult({
    required this.products,
    required this.totalItems,
    required this.totalPages,
    required this.currentPage,
  });
}
