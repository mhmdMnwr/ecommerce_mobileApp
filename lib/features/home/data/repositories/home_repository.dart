import '../data_sources/home_remote_data_source.dart';
import '../models/category_model.dart';
import '../models/product_model.dart';

class HomeRepository {
  final HomeRemoteDataSource _remoteDataSource;

  HomeRepository(this._remoteDataSource);

  Future<List<CategoryModel>> getCategories() =>
      _remoteDataSource.getCategories();

  Future<List<ProductModel>> getNewProducts() =>
      _remoteDataSource.getNewProducts();

  Future<List<ProductModel>> getPopularProducts() =>
      _remoteDataSource.getPopularProducts();
}
