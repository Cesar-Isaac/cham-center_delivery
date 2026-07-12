import '../../../product/domain/entities/product_entity.dart';
import '../entities/cart_entity.dart';

abstract class CartRepository {
  List<CartEntity> getCart();

  Future<void> addProduct(ProductEntity product);

  Future<void> deleteProduct(int productId);

  Future<void> increaseQuantity(int productId);

  Future<void> decreaseQuantity(int productId);

  Future<void> clearCart();
}