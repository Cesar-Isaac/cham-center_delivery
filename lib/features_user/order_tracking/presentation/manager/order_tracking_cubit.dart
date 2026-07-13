import 'dart:async';
import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/route_point_entity.dart';
import '../../domain/usecases/get_order_route_usecase.dart';
import 'order_tracking_state.dart';

class OrderTrackingCubit extends Cubit<OrderTrackingState> {
  final GetOrderRouteUseCase getOrderRouteUseCase;

  Timer? _trackingTimer;
  List<RoutePointEntity> _animationPoints = [];
  int _currentPointIndex = 0;

  OrderTrackingCubit({
    required this.getOrderRouteUseCase,
  }) : super(const OrderTrackingState());

  Future<void> startTracking({
    required double startLatitude,
    required double startLongitude,
    required double endLatitude,
    required double endLongitude,
  }) async {
    _trackingTimer?.cancel();

    emit(
      const OrderTrackingState(
        status: OrderTrackingStatus.loading,
      ),
    );

    try {
      final route = await getOrderRouteUseCase(
        startLatitude: startLatitude,
        startLongitude: startLongitude,
        endLatitude: endLatitude,
        endLongitude: endLongitude,
      );

      _animationPoints = _prepareAnimationPoints(route);
      _currentPointIndex = 0;

      emit(
        state.copyWith(
          status: OrderTrackingStatus.tracking,
          routePoints: route,
          driverLocation: _animationPoints.first,
          progress: 0,
          clearError: true,
        ),
      );

      _startDriverAnimation();
    } catch (e) {
      emit(
        state.copyWith(
          status: OrderTrackingStatus.error,
          error: _cleanError(e),
        ),
      );
    }
  }

  void _startDriverAnimation() {
    _trackingTimer?.cancel();

    _trackingTimer = Timer.periodic(
      const Duration(milliseconds: 500),
          (timer) {
        if (_currentPointIndex >=
            _animationPoints.length - 1) {
          timer.cancel();

          emit(
            state.copyWith(
              status: OrderTrackingStatus.completed,
              driverLocation: _animationPoints.last,
              progress: 1,
            ),
          );

          return;
        }

        _currentPointIndex++;

        final progress = _currentPointIndex /
            (_animationPoints.length - 1);

        emit(
          state.copyWith(
            status: OrderTrackingStatus.tracking,
            driverLocation:
            _animationPoints[_currentPointIndex],
            progress: progress.clamp(0.0, 1.0),
          ),
        );
      },
    );
  }

  List<RoutePointEntity> _prepareAnimationPoints(
      List<RoutePointEntity> route,
      ) {
    const targetNumberOfSteps = 60;

    if (route.length <= targetNumberOfSteps) {
      return route;
    }

    final step = max(
      1,
      (route.length / targetNumberOfSteps).ceil(),
    );

    final points = <RoutePointEntity>[];

    for (int index = 0;
    index < route.length;
    index += step) {
      points.add(route[index]);
    }

    if (points.last != route.last) {
      points.add(route.last);
    }

    return points;
  }

  String _cleanError(Object error) {
    return error
        .toString()
        .replaceFirst('Exception: ', '');
  }

  void stopTracking() {
    _trackingTimer?.cancel();
  }

  @override
  Future<void> close() {
    _trackingTimer?.cancel();
    return super.close();
  }
}