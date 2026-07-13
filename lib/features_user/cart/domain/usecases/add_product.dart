import '../../../product/domain/entities/product_entity.dart';
import '../repositories/cart_repositories.dart';

class AddProductUseCase {
  final CartRepository repository;

  AddProductUseCase(this.repository);

  Future<void> call(ProductEntity product) async {
    await repository.addProduct(product);
  }
}