import '../../domain/entities/route_point_entity.dart';
import '../../domain/repositories/order_tracking_repository.dart';
import '../data_sources/route_remote_data_source.dart';

class OrderTrackingRepositoryImpl
    implements OrderTrackingRepository {
  final RouteRemoteDataSource remoteDataSource;

  OrderTrackingRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<RoutePointEntity>> getRoute({
    required double startLatitude,
    required double startLongitude,
    required double endLatitude,
    required double endLongitude,
  }) {
    return remoteDataSource.getRoute(
      startLatitude: startLatitude,
      startLongitude: startLongitude,
      endLatitude: endLatitude,
      endLongitude: endLongitude,
    );
  }
}