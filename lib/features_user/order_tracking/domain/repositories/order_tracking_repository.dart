import '../entities/route_point_entity.dart';

abstract class OrderTrackingRepository {
  Future<List<RoutePointEntity>> getRoute({
    required double startLatitude,
    required double startLongitude,
    required double endLatitude,
    required double endLongitude,
  });
}