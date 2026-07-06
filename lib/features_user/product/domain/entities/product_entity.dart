class ProductEntity {
  final int id;
  final String name;
  final String image;
  final double price;
  final String? description;
  final bool isAvailable;

  const ProductEntity({
    required this.id,
    required this.name,
    required this.image,
    required this.price,
    this.description,
    this.isAvailable = true,
  });

  ProductEntity copyWith({
    int? id,
    String? name,
    String? image,
    double? price,
    String? description,
    bool? isAvailable,
  }) {
    return ProductEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      image: image ?? this.image,
      price: price ?? this.price,
      description: description ?? this.description,
      isAvailable: isAvailable ?? this.isAvailable,
    );
  }
}