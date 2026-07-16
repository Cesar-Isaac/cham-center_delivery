import '../../../home/domain/entities/store_entity.dart';
import '../../../product/domain/entities/product_entity.dart';

abstract class FavoritesRepository {
  List<ProductEntity> getFavorites();

  Future<void> toggleFavorite(ProductEntity product);

  List<StoreEntity> getFavoriteStores();

  Future<void> toggleFavoriteStore(StoreEntity store);
}
