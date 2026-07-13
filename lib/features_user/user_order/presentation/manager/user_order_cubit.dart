import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../authentication/domain/entities/user_entity.dart';
import '../../../cart/domain/entities/cart_entity.dart';
import '../../../cart/domain/usecases/clear_cart.dart';
import '../../domain/entities/enums.dart';
import '../../domain/entities/order_entity.dart';
import '../../domain/usecases/create_user_order_usecase.dart';
import '../../domain/usecases/get_user_orders_usecase.dart.dart';
import '../../domain/usecases/update_user_order_status_usecase.dart';
import 'user_order_state.dart';

class UserOrderCubit extends Cubit<UserOrderState> {
  final CreateUserOrderUseCase createUserOrderUseCase;
  final GetUserOrdersUseCase getUserOrdersUseCase;
  final UpdateUserOrderStatusUseCase
  updateUserOrderStatusUseCase;
  final ClearCartUseCase clearCartUseCase;

  final Map<String, Timer> _deliveryTimers = {};

  static const Duration deliveryStartDelay =
  Duration(seconds: 5);

  UserOrderCubit({
    required this.createUserOrderUseCase,
    required this.getUserOrdersUseCase,
    required this.updateUserOrderStatusUseCase,
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
      final savedOrders = await getUserOrdersUseCase();

      final synchronizedOrders =
      await _synchronizePendingOrders(savedOrders);

      final sortedOrders =
      List<OrderEntity>.from(synchronizedOrders)
        ..sort(
              (first, second) {
            return second.createdAt.compareTo(
              first.createdAt,
            );
          },
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
          error: _cleanError(e),
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

      await clearCartUseCase();

      final updatedOrders = [
        order,
        ...state.orders.where(
              (savedOrder) => savedOrder.id != order.id,
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

      _scheduleDeliveryStart(order);

      return order;
    } catch (e) {
      emit(
        state.copyWith(
          status: UserOrderStateStatus.error,
          error: _cleanError(e),
        ),
      );

      return null;
    }
  }

  Future<OrderEntity?> updateOrderStatus({
    required String orderId,
    required OrderStatus status,
  }) async {
    try {
      final updatedOrder =
      await updateUserOrderStatusUseCase(
        orderId: orderId,
        status: status,
      );

      final updatedOrders = state.orders.map((order) {
        if (order.id == updatedOrder.id) {
          return updatedOrder;
        }

        return order;
      }).toList();

      emit(
        state.copyWith(
          status: UserOrderStateStatus.loaded,
          orders: updatedOrders,
          clearError: true,
        ),
      );

      return updatedOrder;
    } catch (e) {
      emit(
        state.copyWith(
          status: UserOrderStateStatus.error,
          error: _cleanError(e),
        ),
      );

      return null;
    }
  }

  Future<OrderEntity?> markOrderCompleted(
      String orderId,
      ) {
    _cancelDeliveryTimer(orderId);

    return updateOrderStatus(
      orderId: orderId,
      status: OrderStatus.completed,
    );
  }

  Future<List<OrderEntity>> _synchronizePendingOrders(
      List<OrderEntity> orders,
      ) async {
    final synchronizedOrders = <OrderEntity>[];

    for (final order in orders) {
      if (order.status != OrderStatus.pending) {
        synchronizedOrders.add(order);
        continue;
      }

      final elapsed = DateTime.now().difference(
        order.createdAt,
      );

      if (elapsed >= deliveryStartDelay) {
        final updatedOrder =
        await updateUserOrderStatusUseCase(
          orderId: order.id,
          status: OrderStatus.delivering,
        );

        synchronizedOrders.add(updatedOrder);
      } else {
        synchronizedOrders.add(order);

        _scheduleDeliveryStart(
          order,
          customDelay: deliveryStartDelay - elapsed,
        );
      }
    }

    return synchronizedOrders;
  }

  void _scheduleDeliveryStart(
      OrderEntity order, {
        Duration? customDelay,
      }) {
    if (order.status != OrderStatus.pending) {
      return;
    }

    _cancelDeliveryTimer(order.id);

    final elapsed = DateTime.now().difference(
      order.createdAt,
    );

    final remainingDelay = customDelay ??
        deliveryStartDelay - elapsed;

    if (remainingDelay <= Duration.zero) {
      unawaited(
        updateOrderStatus(
          orderId: order.id,
          status: OrderStatus.delivering,
        ),
      );

      return;
    }

    _deliveryTimers[order.id] = Timer(
      remainingDelay,
          () async {
        _deliveryTimers.remove(order.id);

        await updateOrderStatus(
          orderId: order.id,
          status: OrderStatus.delivering,
        );
      },
    );
  }

  void _cancelDeliveryTimer(String orderId) {
    _deliveryTimers.remove(orderId)?.cancel();
  }

  String _cleanError(Object error) {
    return error
        .toString()
        .replaceFirst('Exception: ', '');
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

  @override
  Future<void> close() {
    for (final timer in _deliveryTimers.values) {
      timer.cancel();
    }

    _deliveryTimers.clear();

    return super.close();
  }
}