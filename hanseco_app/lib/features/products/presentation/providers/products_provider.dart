import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/dio_client.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../data/datasources/product_remote_datasource.dart';
import '../../data/repositories/product_repository_impl.dart';
import '../../domain/entities/product.dart';
import '../../domain/entities/category.dart';
import '../../domain/repositories/product_repository.dart';
import '../../domain/usecases/get_products_usecase.dart';
import '../../domain/usecases/get_product_detail_usecase.dart';

// Remote DataSource Provider
final productRemoteDataSourceProvider = Provider<ProductRemoteDataSource>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return ProductRemoteDataSourceImpl(dioClient.dio);
});

// Repository Provider
final productRepositoryProvider = Provider<ProductRepository>((ref) {
  final remoteDataSource = ref.watch(productRemoteDataSourceProvider);
  return ProductRepositoryImpl(remoteDataSource);
});

// Use Cases
final getProductsUseCaseProvider = Provider<GetProductsUseCase>((ref) {
  final repository = ref.watch(productRepositoryProvider);
  return GetProductsUseCase(repository);
});

final getProductDetailUseCaseProvider = Provider<GetProductDetailUseCase>((ref) {
  final repository = ref.watch(productRepositoryProvider);
  return GetProductDetailUseCase(repository);
});

// Products State
class ProductsState {
  final List<Product> products;
  final bool isLoading;
  final String? error;
  final bool hasMore;
  final int currentPage;

  ProductsState({
    this.products = const [],
    this.isLoading = false,
    this.error,
    this.hasMore = true,
    this.currentPage = 1,
  });

  ProductsState copyWith({
    List<Product>? products,
    bool? isLoading,
    String? error,
    bool? hasMore,
    int? currentPage,
  }) {
    return ProductsState(
      products: products ?? this.products,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      hasMore: hasMore ?? this.hasMore,
      currentPage: currentPage ?? this.currentPage,
    );
  }
}

// Products Notifier
class ProductsNotifier extends StateNotifier<ProductsState> {
  final GetProductsUseCase getProductsUseCase;

  ProductsNotifier({required this.getProductsUseCase}) : super(ProductsState());

  Future<void> fetchProducts({
    bool refresh = false,
    String? categoryId,
    String? searchQuery,
  }) async {
    if (refresh) {
      state = ProductsState(isLoading: true);
    } else if (state.isLoading || !state.hasMore) {
      return;
    } else {
      state = state.copyWith(isLoading: true);
    }

    final page = refresh ? 1 : state.currentPage;

    final result = await getProductsUseCase(
      page: page,
      categoryId: categoryId,
      searchQuery: searchQuery,
    );

    result.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          error: failure.message,
        );
      },
      (newProducts) {
        final allProducts = refresh
            ? newProducts
            : [...state.products, ...newProducts];

        state = state.copyWith(
          products: allProducts,
          isLoading: false,
          error: null,
          hasMore: newProducts.isNotEmpty,
          currentPage: page + 1,
        );
      },
    );
  }

  Future<void> searchProducts(String query) async {
    await fetchProducts(refresh: true, searchQuery: query);
  }

  Future<void> filterByCategory(String? categoryId) async {
    await fetchProducts(refresh: true, categoryId: categoryId);
  }
}

// Products State Notifier Provider
final productsNotifierProvider =
    StateNotifierProvider<ProductsNotifier, ProductsState>((ref) {
  final getProductsUseCase = ref.watch(getProductsUseCaseProvider);

  return ProductsNotifier(getProductsUseCase: getProductsUseCase);
});

// Categories State
class CategoriesState {
  final List<Category> categories;
  final bool isLoading;
  final String? error;

  CategoriesState({
    this.categories = const [],
    this.isLoading = false,
    this.error,
  });

  CategoriesState copyWith({
    List<Category>? categories,
    bool? isLoading,
    String? error,
  }) {
    return CategoriesState(
      categories: categories ?? this.categories,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

// Categories Notifier
class CategoriesNotifier extends StateNotifier<CategoriesState> {
  final ProductRepository repository;

  CategoriesNotifier({required this.repository}) : super(CategoriesState());

  Future<void> fetchCategories() async {
    state = state.copyWith(isLoading: true);

    final result = await repository.getCategories();

    result.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          error: failure.message,
        );
      },
      (categories) {
        state = state.copyWith(
          categories: categories,
          isLoading: false,
          error: null,
        );
      },
    );
  }
}

// Categories Provider
final categoriesNotifierProvider =
    StateNotifierProvider<CategoriesNotifier, CategoriesState>((ref) {
  final repository = ref.watch(productRepositoryProvider);

  return CategoriesNotifier(repository: repository);
});

// Product Detail State
class ProductDetailState {
  final Product? product;
  final bool isLoading;
  final String? error;

  ProductDetailState({
    this.product,
    this.isLoading = false,
    this.error,
  });

  ProductDetailState copyWith({
    Product? product,
    bool? isLoading,
    String? error,
  }) {
    return ProductDetailState(
      product: product ?? this.product,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

// Product Detail Notifier
class ProductDetailNotifier extends StateNotifier<ProductDetailState> {
  final GetProductDetailUseCase getProductDetailUseCase;

  ProductDetailNotifier({required this.getProductDetailUseCase})
      : super(ProductDetailState());

  Future<void> fetchProductDetail(String slug) async {
    state = state.copyWith(isLoading: true);

    final result = await getProductDetailUseCase(slug);

    result.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          error: failure.message,
        );
      },
      (product) {
        state = state.copyWith(
          product: product,
          isLoading: false,
          error: null,
        );
      },
    );
  }
}

// Product Detail Provider (family for different products)
final productDetailNotifierProvider = StateNotifierProvider.family<
    ProductDetailNotifier, ProductDetailState, String>((ref, slug) {
  final getProductDetailUseCase = ref.watch(getProductDetailUseCaseProvider);

  final notifier =
      ProductDetailNotifier(getProductDetailUseCase: getProductDetailUseCase);

  // Auto-fetch on create
  Future.microtask(() => notifier.fetchProductDetail(slug));

  return notifier;
});
