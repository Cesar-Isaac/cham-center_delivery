import '../../domain/entities/product_entity.dart';
import '../../domain/repositories/product_repository.dart';
import '../data_sources/product_local_data.dart';

class ProductRepositoryImpl
    implements ProductRepository {
  const ProductRepositoryImpl(
      this.localDataSource,
      );

  final ProductLocalDataSource localDataSource;

  @override
  Future<List<ProductEntity>>
  getProductsByCategory(
      String category,
      ) {
    return localDataSource.getProductsByCategory(
      category,
    );
  }
}