import '../repositories/cart_repositories.dart';

class DeleteProductUseCase {
  final CartRepository repository;

  DeleteProductUseCase(this.repository);

  Future<void> call(int productId) async {
    await repository.deleteProduct(productId);
  }
}
