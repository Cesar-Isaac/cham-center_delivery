import '../../domain/entities/product_entity.dart';

class ProductModel extends ProductEntity {
  const ProductModel({
    required super.id,
    required super.name,
    required super.image,
    required super.category,
    required super.price,
    super.description,
    super.isAvailable,
  });

  factory ProductModel.fromEntity(
      ProductEntity entity,
      ) {
    return ProductModel(
      id: entity.id,
      name: entity.name,
      image: entity.image,
      category: entity.category,
      price: entity.price,
      description: entity.description,
      isAvailable: entity.isAvailable,
    );
  }

  factory ProductModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return ProductModel(
      id: (json['id'] as num? ?? 0).toInt(),
      name: json['name']?.toString() ?? '',
      image: json['image']?.toString() ?? '',
      category: json['category']?.toString() ?? '',
      price: (json['price'] as num? ?? 0).toDouble(),
      description: json['description']?.toString(),
      isAvailable:
      json['isAvailable'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'category': category,
      'price': price,
      'description': description,
      'isAvailable': isAvailable,
    };
  }
}