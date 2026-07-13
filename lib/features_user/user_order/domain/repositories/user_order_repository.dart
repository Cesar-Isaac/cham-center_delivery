import '../entities/driver_entity.dart';
import '../entities/order_entity.dart';

abstract class UserOrderRepository {
  Future<OrderEntity> createOrder(OrderEntity order);

  Future<List<OrderEntity>> getOrders();

  Future<OrderEntity?> getOrderById(String id);

  DriverEntity getRandomDriver();
}