import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../domain/entities/trip.dart';
import '../../domain/repositories/trip_repository.dart';
import '../../domain/types/location.dart';

class TripSimulationRepository implements TripRepository {
  @override
  Future<Trip> createTrip({required List<dynamic> orders}) {
    throw UnimplementedError();
  }

  @override
  Future<List<Location>> buildRoute({
    required Location from,
    required Location to,
  }) async {
    try {
      final uri = Uri.parse(
        'https://router.project-osrm.org/route/v1/driving/'
        '${from.lng},${from.lat};${to.lng},${to.lat}'
        '?overview=full&geometries=geojson',
      );
      final response = await http
          .get(uri)
          .timeout(const Duration(seconds: 8));

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body) as Map<String, dynamic>;
        final routes = body['routes'] as List?;
        if (routes != null && routes.isNotEmpty) {
          final coords = ((routes.first as Map<String, dynamic>)['geometry']
              ['coordinates']) as List;
          return coords.map((c) {
            final pair = c as List;
            return Location(
              lat: (pair[1] as num).toDouble(),
              lng: (pair[0] as num).toDouble(),
            );
          }).toList();
        }
      }
    } catch (_) {
      // Network error or timeout — fall through to straight-line fallback
    }
    return _straightLine(from, to);
  }

  // Fallback: 30-point straight-line interpolation.
  List<Location> _straightLine(Location from, Location to) {
    const steps = 30;
    return List.generate(steps, (i) {
      final t = (i + 1) / steps;
      return Location(
        lat: from.lat + (to.lat - from.lat) * t,
        lng: from.lng + (to.lng - from.lng) * t,
      );
    });
  }
}
