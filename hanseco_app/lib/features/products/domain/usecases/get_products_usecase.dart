import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/product.dart';
import '../repositories/product_repository.dart';

class GetProductsUseCase {
  final ProductRepository repository;

  GetProductsUseCase(this.repository);

  Future<Either<Failure, List<Product>>> call({
    int page = 1,
    int pageSize = 20,
    String? categoryId,
    String? searchQuery,
  }) async {
    return await repository.getProducts(
      page: page,
      pageSize: pageSize,
      categoryId: categoryId,
      searchQuery: searchQuery,
    );
  }
}
