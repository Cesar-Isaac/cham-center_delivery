import '../entities/home_data_entity.dart';
import '../repositories/home_repository.dart';

class GetHomeDataUseCase {
  GetHomeDataUseCase(this.repository);

  final HomeRepository repository;

  Future<HomeDataEntity> call() {
    return repository.getHomeData();
  }
}