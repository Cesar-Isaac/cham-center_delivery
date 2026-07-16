import '../../../../core/constants/location_constants.dart';
import '../../../../core/utils/order_id_generator.dart';
import '../../../authentication/domain/entities/user_entity.dart';
import '../../../cart/domain/entities/cart_entity.dart';
import '../entities/delivery_entity.dart';
import '../entities/enums.dart';
import '../entities/order_entity.dart';
import '../repositories/user_order_repository.dart';

class CreateUserOrderUseCase {
  final UserOrderRepository repository;

  CreateUserOrderUseCase(this.repository);

  Future<OrderEntity> call({
    required List<CartEntity> cartItems,
    required UserEntity user,
    required PaymentMethod paymentMethod,
    String? deliveryAddress,
    double? deliveryLatitude,
    double? deliveryLongitude,
  }) async {
    if (cartItems.isEmpty) {
      throw Exception('لا يمكن إنشاء طلب من سلة فارغة.');
    }

    final driver = repository.getRandomDriver();

    final delivery = DeliveryEntity(
      from: LocationConstants.mallName,
      to: deliveryAddress ?? user.address,
      fromLatitude: LocationConstants.mallLatitude,
      fromLongitude: LocationConstants.mallLongitude,
      toLatitude: deliveryLatitude ?? user.latitude,
      toLongitude: deliveryLongitude ?? user.longitude,
    );

    final totalPrice = cartItems.fold<double>(
      0,
          (sum, item) => sum + item.totalPrice,
    );

    final order = OrderEntity(
      id: generateOrderId(),
      products: List<CartEntity>.from(cartItems),
      user: user,
      driver: driver,
      delivery: delivery,
      status: OrderStatus.pending,
      paymentMethod: paymentMethod,
      totalPrice: totalPrice,
      createdAt: DateTime.now(),
    );

    return repository.createOrder(order);
  }
}