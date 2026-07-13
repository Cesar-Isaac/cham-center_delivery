import '../entities/order_entity.dart';
import '../repositories/user_order_repository.dart';

class GetUserOrdersUseCase {
  final UserOrderRepository repository;

  GetUserOrdersUseCase(this.repository);

  Future<List<OrderEntity>> call() {
    return repository.getOrders();
  }
}