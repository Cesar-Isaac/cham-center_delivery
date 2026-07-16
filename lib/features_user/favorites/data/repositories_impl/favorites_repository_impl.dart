import '../../../home/domain/entities/store_entity.dart';
import '../../../product/domain/entities/product_entity.dart';
import '../../domain/repositories/favorites_repository.dart';
import '../data_sources/favorites_local_data.dart';

class FavoritesRepositoryImpl implements FavoritesRepository {
  final FavoritesLocalDataSource localDataSource;

  FavoritesRepositoryImpl(this.localDataSource);

  @override
  List<ProductEntity> getFavorites() {
    return localDataSource.getFavorites();
  }

  @override
  Future<void> toggleFavorite(ProductEntity product) {
    return localDataSource.toggleFavorite(product);
  }

  @override
  List<StoreEntity> getFavoriteStores() {
    return localDataSource.getFavoriteStores();
  }

  @override
  Future<void> toggleFavoriteStore(StoreEntity store) {
    return localDataSource.toggleFavoriteStore(store);
  }
}
