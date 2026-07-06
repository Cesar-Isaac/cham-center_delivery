import '../../../product/domain/entities/product_entity.dart';

class CartEntity {
  final ProductEntity product;
  final int quantity;

  const CartEntity({
    required this.product,
    required this.quantity,
  });

  double get totalPrice => product.price * quantity;

  CartEntity copyWith({
    ProductEntity? product,
    int? quantity,
  }) {
    return CartEntity(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
    );
  }
}