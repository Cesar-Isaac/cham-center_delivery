import '../../../home/domain/entities/store_entity.dart';
import '../repositories/favorites_repository.dart';

class GetFavoriteStoresUseCase {
  final FavoritesRepository repository;

  GetFavoriteStoresUseCase(this.repository);

  List<StoreEntity> call() {
    return repository.getFavoriteStores();
  }
}
