import '../repositories/cart_repositories.dart';

class DeleteProductUseCase {
  final CartRepository repository;

  DeleteProductUseCase(this.repository);

  void call(int productId) {
    repository.deleteProduct(productId);
  }
}