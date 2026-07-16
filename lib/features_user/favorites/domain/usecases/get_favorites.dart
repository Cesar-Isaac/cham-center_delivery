import '../../../product/domain/entities/product_entity.dart';
import '../repositories/favorites_repository.dart';

class GetFavoritesUseCase {
  final FavoritesRepository repository;

  GetFavoritesUseCase(this.repository);

  List<ProductEntity> call() {
    return repository.getFavorites();
  }
}
