import '../entities/trip.dart';
import '../types/location.dart';

abstract class TripRepository {
  Future<Trip> createTrip({required List<dynamic> orders});

  /// Generates a simulated route polyline between two points.
  Future<List<Location>> buildRoute({
    required Location from,
    required Location to,
  });
}
