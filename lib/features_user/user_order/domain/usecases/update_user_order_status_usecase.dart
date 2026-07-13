import '../entities/enums.dart';
import '../entities/order_entity.dart';
import '../repositories/user_order_repository.dart';

class UpdateUserOrderStatusUseCase {
  final UserOrderRepository repository;

  UpdateUserOrderStatusUseCase(
      this.repository,
      );

  Future<OrderEntity> call({
    required String orderId,
    required OrderStatus status,
  }) {
    return repository.updateOrderStatus(
      orderId: orderId,
      status: status,
    );
  }
}