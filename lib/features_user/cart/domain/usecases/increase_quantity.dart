import '../repositories/cart_repositories.dart';

class IncreaseQuantityUseCase {
  final CartRepository repository;

  IncreaseQuantityUseCase(this.repository);

  void call(int productId) {
    repository.increaseQuantity(productId);
  }
}