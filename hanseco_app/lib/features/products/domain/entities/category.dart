import 'package:equatable/equatable.dart';

class Category extends Equatable {
  final String id;
  final String name;
  final String slug;
  final String description;
  final String? imageUrl;

  const Category({
    required this.id,
    required this.name,
    required this.slug,
    required this.description,
    this.imageUrl,
  });

  @override
  List<Object?> get props => [id, name, slug, description, imageUrl];
}
