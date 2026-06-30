import 'order_category.dart';
import 'product.dart';

class Order {
  final String id;
  final String customerName;
  final String phone;
  final String pickupAddress;
  final String deliveryAddress;
  final double deliveryLat;
  final double deliveryLng;
  final OrderCategory category;
  final List<Product> products;
  final double price;
  final DateTime createdAt;

  const Order({
    required this.id,
    required this.customerName,
    required this.phone,
    required this.pickupAddress,
    required this.deliveryAddress,
    required this.deliveryLat,
    required this.deliveryLng,
    required this.category,
    required this.products,
    required this.price,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'customerName': customerName,
    'phone': phone,
    'pickupAddress': pickupAddress,
    'deliveryAddress': deliveryAddress,
    'deliveryLat': deliveryLat,
    'deliveryLng': deliveryLng,
    'category': category.name,
    'products': products.map((p) => p.toJson()).toList(),
    'price': price,
    'createdAt': createdAt.toIso8601String(),
  };

  factory Order.fromJson(Map<String, dynamic> json) => Order(
    id: json['id'] as String,
    customerName: json['customerName'] as String,
    phone: json['phone'] as String,
    pickupAddress: json['pickupAddress'] as String,
    deliveryAddress: json['deliveryAddress'] as String,
    deliveryLat: (json['deliveryLat'] as num).toDouble(),
    deliveryLng: (json['deliveryLng'] as num).toDouble(),
    category: OrderCategory.values.firstWhere(
      (c) => c.name == json['category'],
    ),
    products: (json['products'] as List)
        .map((p) => Product.fromJson(p as Map<String, dynamic>))
        .toList(),
    price: (json['price'] as num).toDouble(),
    createdAt: DateTime.parse(json['createdAt'] as String),
  );
}
