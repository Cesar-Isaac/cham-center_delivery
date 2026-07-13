abstract class LocationRepository {
  Future<String> getAddressFromCoordinates({
    required double latitude,
    required double longitude,
  });
}