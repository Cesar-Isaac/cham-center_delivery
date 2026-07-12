import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../cart/domain/entities/cart_entity.dart';
import '../../../cart/domain/usecases/clear_cart.dart';
import '../../domain/entities/enums.dart';
import '../../domain/entities/order_entity.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/usecases/create_user_order_usecase.dart';
import '../../domain/usecases/get_user_orders_usecase.dart.dart';
import 'user_order_state.dart';

class UserOrderCubit extends Cubit<UserOrderState> {
  final CreateUserOrderUseCase createUserOrderUseCase;
  final GetUserOrdersUseCase getUserOrdersUseCase;
  final ClearCartUseCase clearCartUseCase;

  UserOrderCubit({
    required this.createUserOrderUseCase,
    required this.getUserOrdersUseCase,
    required this.clearCartUseCase,
  }) : super(const UserOrderState());

  Future<void> loadOrders() async {
    emit(
      state.copyWith(
        status: UserOrderStateStatus.loading,
        clearError: true,
      ),
    );

    try {
      final orders = await getUserOrdersUseCase();

      // عرض الطلب الأحدث أولاً
      final sortedOrders = List<OrderEntity>.from(orders)
        ..sort(
              (first, second) =>
              second.createdAt.compareTo(first.createdAt),
        );

      emit(
        state.copyWith(
          status: UserOrderStateStatus.loaded,
          orders: sortedOrders,
          clearError: true,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: UserOrderStateStatus.error,
          error: e.toString(),
        ),
      );
    }
  }

  Future<OrderEntity?> createOrder({
    required List<CartEntity> cartItems,
    required UserEntity user,
    required PaymentMethod paymentMethod,
  }) async {
    if (cartItems.isEmpty) {
      emit(
        state.copyWith(
          status: UserOrderStateStatus.error,
          error: 'لا يمكن إنشاء طلب من سلة فارغة.',
        ),
      );

      return null;
    }

    emit(
      state.copyWith(
        status: UserOrderStateStatus.creating,
        clearCreatedOrder: true,
        clearError: true,
      ),
    );

    try {
      final order = await createUserOrderUseCase(
        cartItems: cartItems,
        user: user,
        paymentMethod: paymentMethod,
      );

      // لا يتم تفريغ السلة إلا بعد نجاح حفظ الطلب
      await clearCartUseCase();

      final updatedOrders = [
        order,
        ...state.orders.where(
              (existingOrder) => existingOrder.id != order.id,
        ),
      ];

      emit(
        state.copyWith(
          status: UserOrderStateStatus.created,
          orders: updatedOrders,
          createdOrder: order,
          clearError: true,
        ),
      );

      return order;
    } catch (e) {
      emit(
        state.copyWith(
          status: UserOrderStateStatus.error,
          error: e.toString(),
        ),
      );

      return null;
    }
  }

  void resetCreatedOrder() {
    emit(
      state.copyWith(
        status: UserOrderStateStatus.loaded,
        clearCreatedOrder: true,
        clearError: true,
      ),
    );
  }
}