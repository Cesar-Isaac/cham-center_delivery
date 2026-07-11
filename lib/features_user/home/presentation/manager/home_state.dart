import 'package:equatable/equatable.dart';

import '../../../product/domain/entities/product_entity.dart';
import '../../domain/entities/store_entity.dart';

enum HomeStatus {
  initial,
  loading,
  success,
  failure,
}

class HomeState extends Equatable {
  final HomeStatus status;
  final List<StoreEntity> allStores;
  final List<StoreEntity> filteredStores;
  final List<ProductEntity> popularProducts;
  final List<ProductEntity> recommendedProducts;
  final String selectedCategory;
  final String searchQuery;
  final String errorMessage;

  const HomeState({
    this.status = HomeStatus.initial,
    this.allStores = const [],
    this.filteredStores = const [],
    this.popularProducts = const [],
    this.recommendedProducts = const [],
    this.selectedCategory = 'All',
    this.searchQuery = '',
    this.errorMessage = '',
  });

  HomeState copyWith({
    HomeStatus? status,
    List<StoreEntity>? allStores,
    List<StoreEntity>? filteredStores,
    List<ProductEntity>? popularProducts,
    List<ProductEntity>? recommendedProducts,
    String? selectedCategory,
    String? searchQuery,
    String? errorMessage,
  }) {
    return HomeState(
      status: status ?? this.status,
      allStores: allStores ?? this.allStores,
      filteredStores: filteredStores ?? this.filteredStores,
      popularProducts:
      popularProducts ?? this.popularProducts,
      recommendedProducts:
      recommendedProducts ?? this.recommendedProducts,
      selectedCategory:
      selectedCategory ?? this.selectedCategory,
      searchQuery: searchQuery ?? this.searchQuery,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    allStores,
    filteredStores,
    popularProducts,
    recommendedProducts,
    selectedCategory,
    searchQuery,
    errorMessage,
  ];
}