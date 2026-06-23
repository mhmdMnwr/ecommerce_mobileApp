import 'package:dio/dio.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/utils/api_constants.dart';
import '../../../home/data/models/category_model.dart';
import '../../../home/data/models/product_model.dart';
import '../models/brand_model.dart';

class CategoriesRemoteDataSource {
  final Dio _dio;
  CategoriesRemoteDataSource(this._dio);

  Future<List<CategoryModel>> getCategories() async {
    try {
      final response = await _dio.get(ApiConstants.categories);
      final data = response.data['data'] as List;
      return data.map((e) => CategoryModel.fromJson(e)).toList();
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Error', e.response?.statusCode);
    }
  }

  Future<List<BrandModel>> getBrands() async {
    try {
      final response = await _dio.get(ApiConstants.brands, queryParameters: {'limit': 100});
      final data = response.data['data'] as List;
      return data.map((e) => BrandModel.fromJson(e)).toList();
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Error', e.response?.statusCode);
    }
  }

  Future<List<ProductModel>> getProducts({String? categoryId, String? brandTitle}) async {
    try {
      final params = <String, dynamic>{'limit': 100};
      if (categoryId != null) params['categoryId'] = categoryId;
      if (brandTitle != null) params['brand'] = brandTitle;

      final response = await _dio.get(ApiConstants.products, queryParameters: params);
      final data = response.data['data'] as List;
      return data.map((e) => ProductModel.fromJson(e)).toList();
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Error', e.response?.statusCode);
    }
  }
}
