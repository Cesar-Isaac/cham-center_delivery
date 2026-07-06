import '../repositories/cart_repositories.dart';


class ClearCartUseCase {
  final CartRepository repository;

  ClearCartUseCase(this.repository);

  void call() {
    repository.clearCart();
  }
}