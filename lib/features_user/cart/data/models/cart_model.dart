import '../../../product/data/models/product_model.dart';
import '../../domain/entities/cart_entity.dart';

class CartModel extends CartEntity {
  const CartModel({
    required super.product,
    required super.quantity,
  });

  factory CartModel.fromEntity(
      CartEntity entity,
      ) {
    return CartModel(
      product: ProductModel.fromEntity(
        entity.product,
      ),
      quantity: entity.quantity,
    );
  }

  factory CartModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return CartModel(
      product: ProductModel.fromJson(
        Map<String, dynamic>.from(
          json['product'] as Map,
        ),
      ),
      quantity:
      (json['quantity'] as num? ?? 1).toInt(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product':
      ProductModel.fromEntity(product).toJson(),
      'quantity': quantity,
    };
  }
}