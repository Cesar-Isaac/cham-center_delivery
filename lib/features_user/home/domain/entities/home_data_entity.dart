import '../../../product/domain/entities/product_entity.dart';
import 'store_entity.dart';

class HomeDataEntity {
  final List<StoreEntity> stores;
  final List<ProductEntity> popularProducts;
  final List<ProductEntity> recommendedProducts;

  const HomeDataEntity({
    required this.stores,
    required this.popularProducts,
    required this.recommendedProducts,
  });
}