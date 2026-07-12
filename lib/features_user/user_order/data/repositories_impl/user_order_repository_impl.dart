import '../../domain/entities/driver_entity.dart';
import '../../domain/entities/enums.dart';
import '../../domain/entities/order_entity.dart';
import '../../domain/repositories/user_order_repository.dart';
import '../data_sources/driver_local_data.dart';
import '../data_sources/user_order_local_data.dart';
import '../models/order_model.dart';

class UserOrderRepositoryImpl
    implements UserOrderRepository {
  final UserOrderLocalDataSource localDataSource;

  final UserOrderDriverLocalDataSource
  driverLocalDataSource;

  UserOrderRepositoryImpl(
      this.localDataSource,
      this.driverLocalDataSource,
      );

  @override
  Future<OrderEntity> createOrder(
      OrderEntity order,
      ) {
    return localDataSource.createOrder(
      OrderModel.fromEntity(order),
    );
  }

  @override
  Future<List<OrderEntity>> getOrders() {
    return localDataSource.getOrders();
  }

  @override
  Future<OrderEntity?> getOrderById(
      String id,
      ) async {
    final orders = await localDataSource.getOrders();

    try {
      return orders.firstWhere(
            (order) => order.id == id,
      );
    } catch (_) {
      return null;
    }
  }

  @override
  Future<OrderEntity> updateOrderStatus({
    required String orderId,
    required OrderStatus status,
  }) {
    return localDataSource.updateOrderStatus(
      orderId: orderId,
      status: status,
    );
  }

  @override
  DriverEntity getRandomDriver() {
    return driverLocalDataSource.getRandomDriver();
  }
}