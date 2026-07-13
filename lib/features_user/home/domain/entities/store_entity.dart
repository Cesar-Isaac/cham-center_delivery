import 'package:equatable/equatable.dart';

class StoreEntity extends Equatable {
  final int id;
  final String name;
  final String image;
  final String category;
  final String description;
  final double rating;
  final String deliveryTime;
  final bool isFavorite;
  final bool isOpen;

  const StoreEntity({
    required this.id,
    required this.name,
    required this.image,
    required this.category,
    required this.description,
    required this.rating,
    required this.deliveryTime,
    this.isFavorite = false,
    this.isOpen = true,
  });

  StoreEntity copyWith({
    int? id,
    String? name,
    String? image,
    String? category,
    String? description,
    double? rating,
    String? deliveryTime,
    bool? isFavorite,
    bool? isOpen,
  }) {
    return StoreEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      image: image ?? this.image,
      category: category ?? this.category,
      description: description ?? this.description,
      rating: rating ?? this.rating,
      deliveryTime: deliveryTime ?? this.deliveryTime,
      isFavorite: isFavorite ?? this.isFavorite,
      isOpen: isOpen ?? this.isOpen,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    image,
    category,
    description,
    rating,
    deliveryTime,
    isFavorite,
    isOpen,
  ];
}