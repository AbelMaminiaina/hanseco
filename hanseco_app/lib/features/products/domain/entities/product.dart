import 'package:equatable/equatable.dart';

class Product extends Equatable {
  final String id;
  final String name;
  final String slug;
  final String description;
  final double price;
  final int stock;
  final String? categoryId;
  final String? categoryName;
  final String? brand;
  final String? warranty;
  final bool isActive;
  final bool isInStock;
  final List<String> images;
  final DateTime createdAt;

  const Product({
    required this.id,
    required this.name,
    required this.slug,
    required this.description,
    required this.price,
    required this.stock,
    this.categoryId,
    this.categoryName,
    this.brand,
    this.warranty,
    this.isActive = true,
    this.isInStock = true,
    this.images = const [],
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        slug,
        description,
        price,
        stock,
        categoryId,
        categoryName,
        brand,
        warranty,
        isActive,
        isInStock,
        images,
        createdAt,
      ];
}
