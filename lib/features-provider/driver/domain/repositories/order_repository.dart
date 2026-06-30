import '../entities/order.dart';
import '../types/order_combination.dart';

abstract class OrderRepository {
  List<Order> getFixedOrders();

  bool canCombineOrders({required Order a, required Order b});

  OrderCombinationResult combine({
    required List<Order> current,
    required Order incoming,
  });
}
