import 'package:equatable/equatable.dart';

import '../../domain/entities/order_entity.dart';

enum UserOrderStateStatus {
  initial,
  loading,
  loaded,
  creating,
  created,
  error,
}

class UserOrderState extends Equatable {
  final UserOrderStateStatus status;
  final List<OrderEntity> orders;
  final OrderEntity? createdOrder;
  final String? error;

  const UserOrderState({
    this.status = UserOrderStateStatus.initial,
    this.orders = const [],
    this.createdOrder,
    this.error,
  });

  UserOrderState copyWith({
    UserOrderStateStatus? status,
    List<OrderEntity>? orders,
    OrderEntity? createdOrder,
    String? error,
    bool clearCreatedOrder = false,
    bool clearError = false,
  }) {
    return UserOrderState(
      status: status ?? this.status,
      orders: orders ?? this.orders,
      createdOrder:
      clearCreatedOrder ? null : createdOrder ?? this.createdOrder,
      error: clearError ? null : error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [
    status,
    orders,
    createdOrder,
    error,
  ];
}