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
  Future<void> addProduct(ProductEntity product) async {
    final item = CartEntity(
      product: product,
      quantity: 1,
    );

    await localDataSource.addProduct(item);
  }

  @override
  Future<void> deleteProduct(int productId) async {
    await localDataSource.deleteProduct(productId);
  }

  @override
  Future<void> increaseQuantity(int productId) async {
    await localDataSource.increaseQuantity(productId);
  }

  @override
  Future<void> decreaseQuantity(int productId) async {
    await localDataSource.decreaseQuantity(productId);
  }

  @override
  Future<void> clearCart() async {
    await localDataSource.clearCart();
  }
}