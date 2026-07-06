import '../../../product/domain/entities/product_entity.dart';
import '../entities/cart_entity.dart';

abstract class CartRepository {
  List<CartEntity> getCart();

  void addProduct(ProductEntity product);

  void deleteProduct(int productId);

  void increaseQuantity(int productId);

  void decreaseQuantity(int productId);

  void clearCart();
}