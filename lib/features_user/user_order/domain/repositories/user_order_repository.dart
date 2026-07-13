import '../entities/driver_entity.dart';
import '../entities/enums.dart';
import '../entities/order_entity.dart';

abstract class UserOrderRepository {
  Future<OrderEntity> createOrder(
      OrderEntity order,
      );

  Future<List<OrderEntity>> getOrders();

  Future<OrderEntity?> getOrderById(
      String id,
      );

  Future<OrderEntity> updateOrderStatus({
    required String orderId,
    required OrderStatus status,
  });

  DriverEntity getRandomDriver();
}