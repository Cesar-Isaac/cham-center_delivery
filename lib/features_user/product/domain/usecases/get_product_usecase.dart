import '../entities/product_entity.dart';
import '../repositories/product_repository.dart';

class GetProductsUseCase {
  const GetProductsUseCase(this.repository);

  final ProductRepository repository;

  Future<List<ProductEntity>> call(
      String category,
      ) {
    return repository.getProductsByCategory(
      category,
    );
  }
}