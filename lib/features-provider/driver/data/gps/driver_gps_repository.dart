import 'dart:math';

import 'package:geolocator/geolocator.dart';

import '../../domain/repositories/driver_repository.dart';
import '../../domain/types/location.dart';

/// Uses the device GPS for the initial driver location.
/// Falls back to Damascus centre when GPS is unavailable or permission denied.
class DriverGpsRepository implements DriverRepository {
  // Fallback: Sham Center Mall, Kafr Sousa — the driver's base location.
  static const _damascusCenter = Location(lat: 33.500659, lng: 36.274265);

  @override
  Future<Location> getCurrentDriverLocation() async {
    try {
      final bool serviceEnabled =
          await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return _damascusCenter;

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) return _damascusCenter;
      }
      if (permission == LocationPermission.deniedForever) {
        return _damascusCenter;
      }

      final Position pos = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 8),
        ),
      );
      return Location(lat: pos.latitude, lng: pos.longitude);
    } catch (_) {
      return _damascusCenter;
    }
  }

  @override
  Location moveTowards({
    required Location from,
    required Location to,
    required double stepMeters,
  }) {
    final dx = to.lng - from.lng;
    final dy = to.lat - from.lat;
    final distApprox = sqrt(dx * dx + dy * dy) * 111000;
    if (distApprox <= stepMeters || distApprox == 0) return to;
    final ratio = stepMeters / distApprox;
    return Location(lat: from.lat + dy * ratio, lng: from.lng + dx * ratio);
  }
}
