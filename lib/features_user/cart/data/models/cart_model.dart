import '../../../product/data/product_model.dart';
import '../../domain/entities/cart_entity.dart';

class CartModel extends CartEntity {
  const CartModel({
    required super.product,
    required super.quantity,
  });

  factory CartModel.fromEntity(CartEntity entity) {
    return CartModel(
      product: ProductModel.fromEntity(entity.product),
      quantity: entity.quantity,
    );
  }

  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(
      product: ProductModel.fromJson(json['product']),
      quantity: json['quantity'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product': (product as ProductModel).toJson(),
      'quantity': quantity,
    };
  }
}