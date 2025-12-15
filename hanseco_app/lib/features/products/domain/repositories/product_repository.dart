import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/product.dart';
import '../entities/category.dart';

abstract class ProductRepository {
  Future<Either<Failure, List<Product>>> getProducts({
    int page = 1,
    int pageSize = 20,
    String? categoryId,
    String? searchQuery,
  });

  Future<Either<Failure, Product>> getProductById(String id);

  Future<Either<Failure, Product>> getProductBySlug(String slug);

  Future<Either<Failure, List<Category>>> getCategories();
}
