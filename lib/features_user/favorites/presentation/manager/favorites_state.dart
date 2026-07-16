import 'package:equatable/equatable.dart';

import '../../../home/domain/entities/store_entity.dart';
import '../../../product/domain/entities/product_entity.dart';

class FavoritesState extends Equatable {
  const FavoritesState({
    this.favorites = const [],
    this.favoriteStores = const [],
  });

  final List<ProductEntity> favorites;
  final List<StoreEntity> favoriteStores;

  FavoritesState copyWith({
    List<ProductEntity>? favorites,
    List<StoreEntity>? favoriteStores,
  }) {
    return FavoritesState(
      favorites: favorites ?? this.favorites,
      favoriteStores:
      favoriteStores ?? this.favoriteStores,
    );
  }

  bool isFavorite(int productId) {
    return favorites.any(
          (product) => product.id == productId,
    );
  }

  bool isFavoriteStore(int storeId) {
    return favoriteStores.any(
          (store) => store.id == storeId,
    );
  }

  bool get isEmpty {
    return favorites.isEmpty &&
        favoriteStores.isEmpty;
  }

  @override
  List<Object?> get props => [
    favorites,
    favoriteStores,
  ];
}
