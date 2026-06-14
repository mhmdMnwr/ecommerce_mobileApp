import '../models/brand_model.dart';
import '../../../home/data/models/category_model.dart';
import '../../../home/data/models/product_model.dart';
import '../datasources/categories_remote_data_source.dart';

class CategoriesRepository {
  final CategoriesRemoteDataSource _remote;

  CategoriesRepository(this._remote);

  Future<List<CategoryModel>> getCategories() => _remote.getCategories();
  Future<List<BrandModel>> getBrands() => _remote.getBrands();
  Future<List<ProductModel>> getProducts({String? categoryId, String? brandTitle}) => 
      _remote.getProducts(categoryId: categoryId, brandTitle: brandTitle);
}
