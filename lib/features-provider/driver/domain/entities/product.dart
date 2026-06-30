class Product {
  final String name;
  final int quantity;
  final double price;

  const Product({
    required this.name,
    required this.quantity,
    required this.price,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'quantity': quantity,
    'price': price,
  };

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    name: json['name'] as String,
    quantity: json['quantity'] as int,
    price: (json['price'] as num).toDouble(),
  );
}
