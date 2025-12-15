// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductModel _$ProductModelFromJson(Map<String, dynamic> json) => ProductModel(
      id: json['id'] as String,
      name: json['name'] as String,
      slug: json['slug'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      stock: (json['stock'] as num).toInt(),
      categoryId: json['categoryId'] as String?,
      categoryName: json['categoryName'] as String?,
      brand: json['brand'] as String?,
      warranty: json['warranty'] as String?,
      isActive: json['isActive'] as bool? ?? true,
      isInStock: json['isInStock'] as bool? ?? true,
      images: (json['images'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$ProductModelToJson(ProductModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'slug': instance.slug,
      'description': instance.description,
      'price': instance.price,
      'stock': instance.stock,
      'categoryId': instance.categoryId,
      'categoryName': instance.categoryName,
      'brand': instance.brand,
      'warranty': instance.warranty,
      'isActive': instance.isActive,
      'isInStock': instance.isInStock,
      'images': instance.images,
      'createdAt': instance.createdAt.toIso8601String(),
    };
