import '../../../home/domain/entities/store_entity.dart';
import '../repositories/favorites_repository.dart';

class ToggleFavoriteStoreUseCase {
  final FavoritesRepository repository;

  ToggleFavoriteStoreUseCase(this.repository);

  Future<void> call(StoreEntity store) {
    return repository.toggleFavoriteStore(store);
  }
}
