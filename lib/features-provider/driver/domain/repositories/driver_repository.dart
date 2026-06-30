import '../types/location.dart';

abstract class DriverRepository {
  Future<Location> getCurrentDriverLocation();

  /// Returns a simulated next location for smooth marker movement.
  /// When distance is small enough, it should return location close to destination.
  Location moveTowards({
    required Location from,
    required Location to,
    required double stepMeters,
  });
}
