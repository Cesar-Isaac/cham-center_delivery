import '../../domain/entities/route_point_entity.dart';

class RoutePointModel extends RoutePointEntity {
  const RoutePointModel({
    required super.latitude,
    required super.longitude,
  });

  factory RoutePointModel.fromEntity(
      RoutePointEntity entity,
      ) {
    return RoutePointModel(
      latitude: entity.latitude,
      longitude: entity.longitude,
    );
  }

  /// OSRM GeoJSON يعيد النقطة بالترتيب:
  /// [longitude, latitude]
  factory RoutePointModel.fromOsrmCoordinates(
      List<dynamic> coordinates,
      ) {
    if (coordinates.length < 2) {
      throw const FormatException(
        'Invalid route coordinates.',
      );
    }

    final longitude = coordinates[0];
    final latitude = coordinates[1];

    if (longitude is! num || latitude is! num) {
      throw const FormatException(
        'Route coordinates must be numbers.',
      );
    }

    return RoutePointModel(
      latitude: latitude.toDouble(),
      longitude: longitude.toDouble(),
    );
  }

  factory RoutePointModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return RoutePointModel(
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}