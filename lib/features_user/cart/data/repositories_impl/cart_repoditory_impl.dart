import '../../../product/domain/entities/product_entity.dart';
import '../../domain/entities/cart_entity.dart';
import '../../domain/repositories/cart_repositories.dart';
import '../data_sources/cart_local_data.dart';

class CartRepositoryImpl implements CartRepository {
  final CartLocalDataSource localDataSource;

  CartRepositoryImpl(this.localDataSource);

  @override
  List<CartEntity> getCart() {
    return localDataSource.getCart();
  }

  @override
  void addProduct(ProductEntity product) {
    localDataSource.addProduct(
      CartEntity(product: product, quantity: 1),
    );
  }

  @override
  void deleteProduct(int productId) {
    localDataSource.deleteProduct(productId);
  }

  @override
  void increaseQuantity(int productId) {
    localDataSource.increaseQuantity(productId);
  }

  @override
  void decreaseQuantity(int productId) {
    localDataSource.decreaseQuantity(productId);
  }

  @override
  void clearCart() {
    localDataSource.clearCart();
  }
}