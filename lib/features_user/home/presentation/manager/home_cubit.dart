import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/store_entity.dart';
import '../../domain/usecases/get_home_data_usecase.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit({
    required this.getHomeDataUseCase,
  }) : super(const HomeState());

  final GetHomeDataUseCase getHomeDataUseCase;

  static const List<String> categories = [
    'All',
    'Food',
    'Clothes',
    'Electronics',
    'Electrical',
  ];

  Future<void> loadHome() async {
    emit(
      state.copyWith(
        status: HomeStatus.loading,
        errorMessage: '',
      ),
    );

    try {
      final data = await getHomeDataUseCase();

      emit(
        state.copyWith(
          status: HomeStatus.success,
          allStores: data.stores,
          filteredStores: data.stores,
          popularProducts: data.popularProducts,
          recommendedProducts: data.recommendedProducts,
          selectedCategory: 'All',
          searchQuery: '',
          errorMessage: '',
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: HomeStatus.failure,
          errorMessage:
          'Could not load stores. Please try again.',
        ),
      );
    }
  }

  void searchStores(String query) {
    emit(
      state.copyWith(
        searchQuery: query,
        filteredStores: _filterStores(
          stores: state.allStores,
          category: state.selectedCategory,
          query: query,
        ),
      ),
    );
  }

  void selectCategory(String category) {
    emit(
      state.copyWith(
        selectedCategory: category,
        filteredStores: _filterStores(
          stores: state.allStores,
          category: category,
          query: state.searchQuery,
        ),
      ),
    );
  }

  List<StoreEntity> _filterStores({
    required List<StoreEntity> stores,
    required String category,
    required String query,
  }) {
    final String normalizedQuery =
    query.trim().toLowerCase();

    return stores.where((store) {
      final bool matchesCategory =
          category == 'All' || store.category == category;

      final bool matchesSearch =
          normalizedQuery.isEmpty ||
              store.name.toLowerCase().contains(normalizedQuery) ||
              store.category
                  .toLowerCase()
                  .contains(normalizedQuery) ||
              store.description
                  .toLowerCase()
                  .contains(normalizedQuery);

      return matchesCategory && matchesSearch;
    }).toList();
  }
}