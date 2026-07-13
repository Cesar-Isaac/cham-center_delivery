import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../home/domain/entities/store_entity.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/usecases/get_product_usecase.dart';
import 'product_state.dart';

class ProductCubit extends Cubit<ProductState> {
  ProductCubit({
    required this.getProductsUseCase,
  }) : super(const ProductState());

  final GetProductsUseCase getProductsUseCase;

  Future<void> loadProducts(
      StoreEntity store,
      ) async {
    emit(
      state.copyWith(
        status: ProductStatus.loading,
        store: store,
        searchQuery: '',
        selectedCategory: 'All',
        errorMessage: '',
      ),
    );

    try {
      final List<ProductEntity> products =
      await getProductsUseCase(
        store.category,
      );

      emit(
        state.copyWith(
          status: ProductStatus.success,
          store: store,
          allProducts: products,
          filteredProducts: products,
          searchQuery: '',
          selectedCategory: 'All',
          errorMessage: '',
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: ProductStatus.failure,
          errorMessage:
          'Could not load products. Please try again.',
        ),
      );
    }
  }

  void searchProducts(String query) {
    emit(
      state.copyWith(
        searchQuery: query,
        filteredProducts: _filterProducts(
          products: state.allProducts,
          query: query,
          category: state.selectedCategory,
        ),
      ),
    );
  }

  void selectCategory(String category) {
    emit(
      state.copyWith(
        selectedCategory: category,
        filteredProducts: _filterProducts(
          products: state.allProducts,
          query: state.searchQuery,
          category: category,
        ),
      ),
    );
  }

  void toggleFavorite(int productId) {
    final List<int> updatedIds =
    List<int>.from(state.favoriteIds);

    if (updatedIds.contains(productId)) {
      updatedIds.remove(productId);
    } else {
      updatedIds.add(productId);
    }

    emit(
      state.copyWith(
        favoriteIds: updatedIds,
      ),
    );
  }

  List<ProductEntity> _filterProducts({
    required List<ProductEntity> products,
    required String query,
    required String category,
  }) {
    final normalizedQuery =
    query.trim().toLowerCase();

    return products.where((product) {
      final bool matchesCategory =
          category == 'All' ||
              product.category == category;

      final bool matchesSearch =
          normalizedQuery.isEmpty ||
              product.name
                  .toLowerCase()
                  .contains(normalizedQuery) ||
              product.category
                  .toLowerCase()
                  .contains(normalizedQuery) ||
              (product.description ?? '')
                  .toLowerCase()
                  .contains(normalizedQuery);

      return matchesCategory && matchesSearch;
    }).toList();
  }
}