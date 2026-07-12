import 'package:equatable/equatable.dart';

import '../../domain/entities/route_point_entity.dart';

enum OrderTrackingStatus {
  initial,
  loading,
  tracking,
  completed,
  error,
}

class OrderTrackingState extends Equatable {
  final OrderTrackingStatus status;
  final List<RoutePointEntity> routePoints;
  final RoutePointEntity? driverLocation;
  final double progress;
  final String? error;

  const OrderTrackingState({
    this.status = OrderTrackingStatus.initial,
    this.routePoints = const [],
    this.driverLocation,
    this.progress = 0,
    this.error,
  });

  OrderTrackingState copyWith({
    OrderTrackingStatus? status,
    List<RoutePointEntity>? routePoints,
    RoutePointEntity? driverLocation,
    double? progress,
    String? error,
    bool clearError = false,
  }) {
    return OrderTrackingState(
      status: status ?? this.status,
      routePoints: routePoints ?? this.routePoints,
      driverLocation:
      driverLocation ?? this.driverLocation,
      progress: progress ?? this.progress,
      error: clearError ? null : error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [
    status,
    routePoints,
    driverLocation,
    progress,
    error,
  ];
}