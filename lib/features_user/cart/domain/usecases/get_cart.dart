import '../repositories/cart_repositories.dart';
import '../entities/cart_entity.dart';

class GetCartUseCase {
  final CartRepository repository;

  GetCartUseCase(this.repository);

  List<CartEntity> call() {
    return repository.getCart();
  }
}