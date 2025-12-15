import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/product.dart';

part 'product_model.g.dart';

@JsonSerializable()
class ProductModel extends Product {
  const ProductModel({
    required super.id,
    required super.name,
    required super.slug,
    required super.description,
    required super.price,
    required super.stock,
    super.categoryId,
    super.categoryName,
    super.brand,
    super.warranty,
    super.isActive,
    super.isInStock,
    super.images,
    required super.createdAt,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    // Handle different JSON structures from API
    return ProductModel(
      id: json['id'].toString(),
      name: json['name'] as String,
      slug: json['slug'] as String,
      description: json['description'] as String? ?? '',
      price: (json['price'] is String)
          ? double.parse(json['price'])
          : (json['price'] as num).toDouble(),
      stock: json['stock'] as int? ?? 0,
      categoryId: json['category']?.toString(),
      categoryName: json['category_name'] as String?,
      brand: json['brand'] as String?,
      warranty: json['warranty'] as String?,
      isActive: json['is_active'] as bool? ?? true,
      isInStock: json['is_in_stock'] as bool? ?? true,
      images: _parseImages(json['images']),
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  static List<String> _parseImages(dynamic imagesData) {
    if (imagesData == null) return [];
    if (imagesData is List) {
      return imagesData
          .map((img) {
            if (img is String) return img;
            if (img is Map) return img['image'] as String? ?? '';
            return '';
          })
          .where((url) => url.isNotEmpty)
          .toList();
    }
    return [];
  }

  Map<String, dynamic> toJson() => _$ProductModelToJson(this);

  factory ProductModel.fromEntity(Product product) {
    return ProductModel(
      id: product.id,
      name: product.name,
      slug: product.slug,
      description: product.description,
      price: product.price,
      stock: product.stock,
      categoryId: product.categoryId,
      categoryName: product.categoryName,
      brand: product.brand,
      warranty: product.warranty,
      isActive: product.isActive,
      isInStock: product.isInStock,
      images: product.images,
      createdAt: product.createdAt,
    );
  }
}
