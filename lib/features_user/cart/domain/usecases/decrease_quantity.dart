import '../repositories/cart_repositories.dart';

class DecreaseQuantityUseCase {
  final CartRepository repository;

  DecreaseQuantityUseCase(this.repository);

  void call(int productId) {
    repository.decreaseQuantity(productId);
  }
}