import '../../domain/repositories/location_repository.dart';
import '../data_sources/location_remote_data_source.dart';

class LocationRepositoryImpl
    implements LocationRepository {
  const LocationRepositoryImpl(
      this.remoteDataSource,
      );

  final LocationRemoteDataSource remoteDataSource;

  @override
  Future<String> getAddressFromCoordinates({
    required double latitude,
    required double longitude,
  }) {
    return remoteDataSource.getAddressFromCoordinates(
      latitude: latitude,
      longitude: longitude,
    );
  }
}