import 'package:dio/dio.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/utils/api_constants.dart';
import '../models/category_model.dart';
import '../models/product_model.dart';

/// Handles API calls for the Home screen.
class HomeRemoteDataSource {
  final Dio _dio;

  HomeRemoteDataSource(this._dio);

  Future<List<CategoryModel>> getCategories() async {
    try {
      final response = await _dio.get(ApiConstants.categories);
      final List data = response.data['data'] as List;
      return data
          .map((json) => CategoryModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw _mapDioError(e);
    }
  }

  Future<List<ProductModel>> getNewProducts() async {
    try {
      final response = await _dio.get(ApiConstants.newProducts);
      final List data = response.data['data'] as List;
      return data
          .map((json) => ProductModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw _mapDioError(e);
    }
  }

  Future<List<ProductModel>> getPopularProducts() async {
    try {
      final response = await _dio.get(ApiConstants.topProducts);
      final List data = response.data['data'] as List;
      return data
          .map((json) => ProductModel.fromJson(json as Map<String, dynamic>))
          .toList();
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
