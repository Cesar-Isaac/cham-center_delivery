import '../repositories/cart_repositories.dart';

class IncreaseQuantityUseCase {
  final CartRepository repository;

  IncreaseQuantityUseCase(this.repository);

  Future<void> call(int productId) async {
    await repository.increaseQuantity(productId);
  }
}
