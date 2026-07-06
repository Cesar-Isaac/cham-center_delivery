import 'package:equatable/equatable.dart';
import '../../domain/entities/cart_entity.dart';

class CartState extends Equatable {
  final List<CartEntity> items;
  final bool loading;
  final String? error;

  const CartState({
    this.items = const [],
    this.loading = false,
    this.error,
  });

  CartState copyWith({
    List<CartEntity>? items,
    bool? loading,
    String? error,
  }) {
    return CartState(
      items: items ?? this.items,
      loading: loading ?? this.loading,
      error: error,
    );
  }

  double get totalPrice =>
      items.fold(0, (sum, item) => sum + item.totalPrice);

  int get totalItems =>
      items.fold(0, (sum, item) => sum + item.quantity);

  @override
  List<Object?> get props => [items, loading, error];
}