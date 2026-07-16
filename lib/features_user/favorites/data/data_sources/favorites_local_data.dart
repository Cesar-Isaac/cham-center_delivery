import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../home/data/models/store_model.dart';
import '../../../home/domain/entities/store_entity.dart';
import '../../../product/data/models/product_model.dart';
import '../../../product/domain/entities/product_entity.dart';

class FavoritesLocalDataSource {
  static const String _favoritesKey = 'favorite_products';
  static const String _favoriteStoresKey = 'favorite_stores';

  final SharedPreferences sharedPreferences;

  FavoritesLocalDataSource(this.sharedPreferences);

  List<ProductEntity> getFavorites() {
    final jsonList =
        sharedPreferences.getStringList(_favoritesKey) ?? [];

    return jsonList.map<ProductEntity>((item) {
      final decoded = jsonDecode(item);

      final json = Map<String, dynamic>.from(
        decoded as Map,
      );

      return ProductModel.fromJson(json);
    }).toList();
  }

  Future<void> toggleFavorite(ProductEntity product) async {
    final favorites = getFavorites();

    final index = favorites.indexWhere(
          (element) => element.id == product.id,
    );

    if (index != -1) {
      favorites.removeAt(index);
    } else {
      favorites.add(product);
    }

    await _saveFavorites(favorites);
  }

  Future<void> _saveFavorites(
      List<ProductEntity> favorites,
      ) async {
    final jsonList = favorites.map((product) {
      final model = ProductModel.fromEntity(product);
      return jsonEncode(model.toJson());
    }).toList();

    await sharedPreferences.setStringList(
      _favoritesKey,
      jsonList,
    );
  }

  List<StoreEntity> getFavoriteStores() {
    final jsonList = sharedPreferences
        .getStringList(_favoriteStoresKey) ??
        [];

    return jsonList.map<StoreEntity>((item) {
      final decoded = jsonDecode(item);

      final json = Map<String, dynamic>.from(
        decoded as Map,
      );

      return StoreModel.fromJson(json);
    }).toList();
  }

  Future<void> toggleFavoriteStore(
      StoreEntity store,
      ) async {
    final stores = getFavoriteStores();

    final index = stores.indexWhere(
          (element) => element.id == store.id,
    );

    if (index != -1) {
      stores.removeAt(index);
    } else {
      // نخزن المتجر كمفضل حتى يظهر القلب مفعلاً عند عرضه.
      stores.add(store.copyWith(isFavorite: true));
    }

    await _saveFavoriteStores(stores);
  }

  Future<void> _saveFavoriteStores(
      List<StoreEntity> stores,
      ) async {
    final jsonList = stores.map((store) {
      final model = StoreModel.fromEntity(store);
      return jsonEncode(model.toJson());
    }).toList();

    await sharedPreferences.setStringList(
      _favoriteStoresKey,
      jsonList,
    );
  }
}
