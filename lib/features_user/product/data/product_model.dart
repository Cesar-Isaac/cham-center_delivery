import '../domain/entities/product_entity.dart';

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

  factory ProductModel.fromEntity(ProductEntity entity) {
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

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      name: json['name'],
      image: json['image'],
      category: json['category'],
      price: (json['price'] as num).toDouble(),
      description: json['description'],
      isAvailable: json['isAvailable'] ?? true,
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