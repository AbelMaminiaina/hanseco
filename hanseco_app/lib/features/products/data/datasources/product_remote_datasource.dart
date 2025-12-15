import 'package:dio/dio.dart';

import '../models/product_model.dart';
import '../models/category_model.dart';

abstract class ProductRemoteDataSource {
  Future<List<ProductModel>> getProducts({
    int page = 1,
    int pageSize = 20,
    String? categoryId,
    String? searchQuery,
  });

  Future<ProductModel> getProductById(String id);

  Future<ProductModel> getProductBySlug(String slug);

  Future<List<CategoryModel>> getCategories();
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final Dio dio;

  ProductRemoteDataSourceImpl(this.dio);

  @override
  Future<List<ProductModel>> getProducts({
    int page = 1,
    int pageSize = 20,
    String? categoryId,
    String? searchQuery,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'page': page,
        'page_size': pageSize,
      };

      if (categoryId != null) {
        queryParams['category'] = categoryId;
      }

      if (searchQuery != null && searchQuery.isNotEmpty) {
        queryParams['search'] = searchQuery;
      }

      final response = await dio.get(
        '/products/',
        queryParameters: queryParams,
      );

      // Handle paginated response
      final results = response.data['results'] ?? response.data;

      if (results is List) {
        return results
            .map((json) => ProductModel.fromJson(json as Map<String, dynamic>))
            .toList();
      }

      return [];
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ProductModel> getProductById(String id) async {
    try {
      final response = await dio.get('/products/$id/');
      return ProductModel.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ProductModel> getProductBySlug(String slug) async {
    try {
      final response = await dio.get('/products/$slug/');
      return ProductModel.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<CategoryModel>> getCategories() async {
    try {
      final response = await dio.get('/products/categories/');

      final results = response.data['results'] ?? response.data;

      if (results is List) {
        return results
            .map((json) => CategoryModel.fromJson(json as Map<String, dynamic>))
            .toList();
      }

      return [];
    } catch (e) {
      rethrow;
    }
  }
}
