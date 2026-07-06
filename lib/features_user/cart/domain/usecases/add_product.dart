import '../../../product/domain/entities/product_entity.dart';
import '../repositories/cart_repositories.dart';

class AddProductUseCase {
  final CartRepository repository;

  AddProductUseCase(this.repository);

  void call(ProductEntity product) {
    repository.addProduct(product);
  }
}