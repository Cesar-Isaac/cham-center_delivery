import '../entities/route_point_entity.dart';
import '../repositories/order_tracking_repository.dart';

class GetOrderRouteUseCase {
  final OrderTrackingRepository repository;

  GetOrderRouteUseCase(this.repository);

  Future<List<RoutePointEntity>> call({
    required double startLatitude,
    required double startLongitude,
    required double endLatitude,
    required double endLongitude,
  }) async {
    _validateCoordinates(
      latitude: startLatitude,
      longitude: startLongitude,
      locationName: 'موقع بداية التوصيل',
    );

    _validateCoordinates(
      latitude: endLatitude,
      longitude: endLongitude,
      locationName: 'موقع المستخدم',
    );

    final isSameLocation =
        startLatitude == endLatitude &&
            startLongitude == endLongitude;

    if (isSameLocation) {
      throw Exception(
        'موقع البداية وموقع المستخدم متطابقان.',
      );
    }

    final route = await repository.getRoute(
      startLatitude: startLatitude,
      startLongitude: startLongitude,
      endLatitude: endLatitude,
      endLongitude: endLongitude,
    );

    if (route.isEmpty) {
      throw Exception(
        'لم يتم العثور على مسار للتوصيل.',
      );
    }

    if (route.length < 2) {
      throw Exception(
        'مسار التوصيل غير مكتمل.',
      );
    }

    return route;
  }

  void _validateCoordinates({
    required double latitude,
    required double longitude,
    required String locationName,
  }) {
    final latitudeIsValid =
        latitude >= -90 && latitude <= 90;

    final longitudeIsValid =
        longitude >= -180 && longitude <= 180;

    if (!latitudeIsValid || !longitudeIsValid) {
      throw Exception(
        'إحداثيات $locationName غير صحيحة.',
      );
    }

    if (latitude == 0 && longitude == 0) {
      throw Exception(
        'لم يتم تحديد $locationName.',
      );
    }
  }
}