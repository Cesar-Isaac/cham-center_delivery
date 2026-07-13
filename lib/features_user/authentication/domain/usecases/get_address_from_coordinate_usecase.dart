import '../repositories/location_repository.dart';

class GetAddressFromCoordinatesUseCase {
  const GetAddressFromCoordinatesUseCase(
      this.repository,
      );

  final LocationRepository repository;

  Future<String> call({
    required double latitude,
    required double longitude,
  }) {
    return repository.getAddressFromCoordinates(
      latitude: latitude,
      longitude: longitude,
    );
  }
}