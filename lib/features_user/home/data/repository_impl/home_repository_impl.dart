import '../../domain/entities/home_data_entity.dart';
import '../../domain/repositories/home_repository.dart';
import '../data_sources/home_local_data_source.dart';

class HomeRepositoryImpl implements HomeRepository {
  HomeRepositoryImpl(this.localDataSource);

  final HomeLocalDataSource localDataSource;

  @override
  Future<HomeDataEntity> getHomeData() {
    return localDataSource.getHomeData();
  }
}