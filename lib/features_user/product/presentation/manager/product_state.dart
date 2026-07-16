import 'package:equatable/equatable.dart';

import '../../../home/domain/entities/store_entity.dart';
import '../../domain/entities/product_entity.dart';

enum ProductStatus {
  initial,
  loading,
  success,
  failure,
}

class ProductState extends Equatable {
  const ProductState({
    this.status = ProductStatus.initial,
    this.store,
    this.allProducts = const [],
    this.filteredProducts = const [],
    this.searchQuery = '',
    this.selectedCategory = 'All',
    this.errorMessage = '',
  });

  final ProductStatus status;
  final StoreEntity? store;

  final List<ProductEntity> allProducts;
  final List<ProductEntity> filteredProducts;

  final String searchQuery;
  final String selectedCategory;
  final String errorMessage;

  ProductState copyWith({
    ProductStatus? status,
    StoreEntity? store,
    List<ProductEntity>? allProducts,
    List<ProductEntity>? filteredProducts,
    String? searchQuery,
    String? selectedCategory,
    String? errorMessage,
  }) {
    return ProductState(
      status: status ?? this.status,
      store: store ?? this.store,
      allProducts: allProducts ?? this.allProducts,
      filteredProducts:
      filteredProducts ?? this.filteredProducts,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedCategory:
      selectedCategory ?? this.selectedCategory,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  double ratingFor(int productId) {
    return 4.0 + ((productId % 9) / 10);
  }

  List<String> get categories {
    final values = allProducts
        .map((product) => product.category)
        .toSet()
        .toList();

    return ['All', ...values];
  }

  @override
  List<Object?> get props => [
    status,
    store,
    allProducts,
    filteredProducts,
    searchQuery,
    selectedCategory,
    errorMessage,
  ];
}