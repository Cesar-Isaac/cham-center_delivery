import '../../../product/domain/entities/product_entity.dart';
import '../repositories/favorites_repository.dart';

class ToggleFavoriteUseCase {
  final FavoritesRepository repository;

  ToggleFavoriteUseCase(this.repository);

  Future<void> call(ProductEntity product) {
    return repository.toggleFavorite(product);
  }
}
