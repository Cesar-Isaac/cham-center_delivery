import 'package:equatable/equatable.dart';

class RoutePointEntity extends Equatable {
  final double latitude;
  final double longitude;

  const RoutePointEntity({
    required this.latitude,
    required this.longitude,
  });

  bool get isValid {
    return latitude >= -90 &&
        latitude <= 90 &&
        longitude >= -180 &&
        longitude <= 180;
  }

  @override
  List<Object?> get props => [
    latitude,
    longitude,
  ];
}