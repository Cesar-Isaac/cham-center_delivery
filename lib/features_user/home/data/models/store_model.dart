import '../../domain/entities/store_entity.dart';

class StoreModel extends StoreEntity {
  const StoreModel({
    required super.id,
    required super.name,
    required super.image,
    required super.category,
    required super.description,
    required super.rating,
    required super.deliveryTime,
    super.isFavorite,
    super.isOpen,
  });

  factory StoreModel.fromEntity(
      StoreEntity entity,
      ) {
    return StoreModel(
      id: entity.id,
      name: entity.name,
      image: entity.image,
      category: entity.category,
      description: entity.description,
      rating: entity.rating,
      deliveryTime: entity.deliveryTime,
      isFavorite: entity.isFavorite,
      isOpen: entity.isOpen,
    );
  }

  factory StoreModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return StoreModel(
      id: (json['id'] as num? ?? 0).toInt(),
      name: json['name']?.toString() ?? '',
      image: json['image']?.toString() ?? '',
      category: json['category']?.toString() ?? '',
      description:
      json['description']?.toString() ?? '',
      rating:
      (json['rating'] as num? ?? 0).toDouble(),
      deliveryTime:
      json['deliveryTime']?.toString() ?? '',
      isFavorite:
      json['isFavorite'] as bool? ?? false,
      isOpen: json['isOpen'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'category': category,
      'description': description,
      'rating': rating,
      'deliveryTime': deliveryTime,
      'isFavorite': isFavorite,
      'isOpen': isOpen,
    };
  }
}
