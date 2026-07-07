class ProductEntity {
  final int id;
  final String name;
  final String image;
  final String category;
  final double price;
  final String? description;
  final bool isAvailable;

  const ProductEntity( {
    required this.id,
    required this.name,
    required this.image,
    required this.category,
    required this.price,
    this.description,
    this.isAvailable = true,
  });

  ProductEntity copyWith({
    int? id,
    String? name,
    String? image,
    String? category,
    double? price,
    String? description,
    bool? isAvailable,
  }) {
    return ProductEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      image: image ?? this.image,
      category: category ?? this.category,
      price: price ?? this.price,
      description: description ?? this.description,
      isAvailable: isAvailable ?? this.isAvailable,
    );
  }
}