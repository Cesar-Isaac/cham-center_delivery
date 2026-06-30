import 'dart:math';

import '../../domain/repositories/driver_repository.dart';
import '../../domain/types/location.dart';

class DriverSimulationRepository implements DriverRepository {
  @override
  Future<Location> getCurrentDriverLocation() async {
    // Start around Damascus center.
    return const Location(lat: 33.5138, lng: 36.2765);
  }

  @override
  Location moveTowards({
    required Location from,
    required Location to,
    required double stepMeters,
  }) {
    // Very rough conversion: 1 deg latitude ~= 111_000 m
    final dx = (to.lng - from.lng);
    final dy = (to.lat - from.lat);

    final distanceMetersApprox = sqrt((dx * dx + dy * dy)) * 111000;
    if (distanceMetersApprox <= stepMeters || distanceMetersApprox == 0) {
      return to;
    }

    final ratio = stepMeters / distanceMetersApprox;
    return Location(lat: from.lat + dy * ratio, lng: from.lng + dx * ratio);
  }
}
