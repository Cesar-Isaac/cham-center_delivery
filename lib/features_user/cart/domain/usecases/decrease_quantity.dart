import '../repositories/cart_repositories.dart';

class DecreaseQuantityUseCase {
  final CartRepository repository;

  DecreaseQuantityUseCase(this.repository);

  Future<void> call(int productId) async {
    await repository.decreaseQuantity(productId);
  }
}
