import '../../../cart/domain/entities/cart_entity.dart';
import 'delivery_entity.dart';
import 'driver_entity.dart';
import 'enums.dart';
import 'user_entity.dart';

class OrderEntity {
  final String id;
  final List<CartEntity> products;
  final UserEntity user;
  final DriverEntity driver;
  final DeliveryEntity delivery;
  final OrderStatus status;
  final PaymentMethod paymentMethod;
  final double totalPrice;
  final DateTime createdAt;

  const OrderEntity({
    required this.id,
    required this.products,
    required this.user,
    required this.driver,
    required this.delivery,
    required this.status,
    required this.paymentMethod,
    required this.totalPrice,
    required this.createdAt,
  });

  int get totalItems {
    return products.fold(
      0,
          (sum, item) => sum + item.quantity,
    );
  }

  OrderEntity copyWith({
    String? id,
    List<CartEntity>? products,
    UserEntity? user,
    DriverEntity? driver,
    DeliveryEntity? delivery,
    OrderStatus? status,
    PaymentMethod? paymentMethod,
    double? totalPrice,
    DateTime? createdAt,
  }) {
    return OrderEntity(
      id: id ?? this.id,
      products: products ?? this.products,
      user: user ?? this.user,
      driver: driver ?? this.driver,
      delivery: delivery ?? this.delivery,
      status: status ?? this.status,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      totalPrice: totalPrice ?? this.totalPrice,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}