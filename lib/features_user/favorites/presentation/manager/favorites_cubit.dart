import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../home/domain/entities/store_entity.dart';
import '../../../product/domain/entities/product_entity.dart';
import '../../domain/usecases/get_favorite_stores.dart';
import '../../domain/usecases/get_favorites.dart';
import '../../domain/usecases/toggle_favorite.dart';
import '../../domain/usecases/toggle_favorite_store.dart';
import 'favorites_state.dart';

class FavoritesCubit extends Cubit<FavoritesState> {
  FavoritesCubit({
    required this.getFavoritesUseCase,
    required this.toggleFavoriteUseCase,
    required this.getFavoriteStoresUseCase,
    required this.toggleFavoriteStoreUseCase,
  }) : super(const FavoritesState());

  final GetFavoritesUseCase getFavoritesUseCase;
  final ToggleFavoriteUseCase toggleFavoriteUseCase;
  final GetFavoriteStoresUseCase
  getFavoriteStoresUseCase;
  final ToggleFavoriteStoreUseCase
  toggleFavoriteStoreUseCase;

  void loadFavorites() {
    emit(
      state.copyWith(
        favorites: getFavoritesUseCase(),
        favoriteStores: getFavoriteStoresUseCase(),
      ),
    );
  }

  Future<void> toggleFavorite(
      ProductEntity product,
      ) async {
    await toggleFavoriteUseCase(product);
    loadFavorites();
  }

  Future<void> toggleStoreFavorite(
      StoreEntity store,
      ) async {
    await toggleFavoriteStoreUseCase(store);
    loadFavorites();
  }
}
