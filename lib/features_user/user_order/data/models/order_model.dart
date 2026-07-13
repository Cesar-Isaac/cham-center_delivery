import '../../../authentication/data/models/user_model.dart';
import '../../domain/entities/order_entity.dart';
import '../../domain/entities/enums.dart';

import '../../../cart/data/models/cart_model.dart';
import 'delivery_model.dart';
import 'driver_model.dart';


class OrderModel extends OrderEntity {
  const OrderModel({
    required super.id,
    required super.products,
    required super.user,
    required super.driver,
    required super.delivery,
    required super.status,
    required super.paymentMethod,
    required super.totalPrice,
    required super.createdAt,
  });

  factory OrderModel.fromEntity(OrderEntity entity) {
    return OrderModel(
      id: entity.id,
      products: entity.products,
      user: entity.user,
      driver: entity.driver,
      delivery: entity.delivery,
      status: entity.status,
      paymentMethod: entity.paymentMethod,
      totalPrice: entity.totalPrice,
      createdAt: entity.createdAt,
    );
  }

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] ?? '',

      products: (json['products'] as List<dynamic>? ?? const [])
          .map((e) => CartModel.fromJson(
        Map<String, dynamic>.from(e as Map),
      ))
          .toList(),

      user: UserModel.fromJson(
        Map<String, dynamic>.from(json['user'] as Map),
      ),

      driver: DriverModel.fromJson(
        Map<String, dynamic>.from(json['driver'] as Map),
      ),

      delivery: DeliveryModel.fromJson(
        Map<String, dynamic>.from(json['delivery'] as Map),
      ),

      status: OrderStatus.values.firstWhere(
            (e) => e.name == json['status'],
        orElse: () => OrderStatus.pending,
      ),

      paymentMethod: PaymentMethod.values.firstWhere(
            (e) => e.name == json['paymentMethod'],
        orElse: () => PaymentMethod.cash,
      ),

      totalPrice: (json['totalPrice'] as num? ?? 0).toDouble(),

      createdAt: DateTime.tryParse(
        json['createdAt']?.toString() ?? '',
      ) ??
          DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,

      'products': products
          .map((e) => CartModel.fromEntity(e).toJson())
          .toList(),

      'user': UserModel.fromEntity(user).toJson(),

      'driver': DriverModel.fromEntity(driver).toJson(),

      'delivery': DeliveryModel.fromEntity(delivery).toJson(),

      'status': status.name,

      'paymentMethod': paymentMethod.name,

      'totalPrice': totalPrice,

      'createdAt': createdAt.toIso8601String(),
    };
  }
}
