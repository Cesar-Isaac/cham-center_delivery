import '../entities/order.dart';

class OrderCombinationResult {
  final bool allowed;
  final List<Order> combinedOrders;
  final String? reason;

  const OrderCombinationResult({
    required this.allowed,
    required this.combinedOrders,
    this.reason,
  });
}
