import 'dart:async';
import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/style/repo/app_colors.dart';
import '../../../domain/entities/order.dart';
import '../../../domain/entities/trip.dart';
import '../../../domain/repositories/trip_repository.dart';
import '../../../domain/types/location.dart';

// ── State ─────────────────────────────────────────────────────────────────────

class TripState {
  final Trip? trip;
  final Location? driverLocation;
  final List<Location> route;
  final bool isTracking;
  final int currentStopIndex;
  final List<bool> deliveredStops;
  final bool isReturningToBase;

  const TripState({
    required this.trip,
    required this.driverLocation,
    required this.route,
    required this.isTracking,
    required this.currentStopIndex,
    required this.deliveredStops,
    required this.isReturningToBase,
  });

  factory TripState.initial() => const TripState(
    trip: null,
    driverLocation: null,
    route: [],
    isTracking: false,
    currentStopIndex: 0,
    deliveredStops: [],
    isReturningToBase: false,
  );

  TripState copyWith({
    Trip? trip,
    Location? driverLocation,
    List<Location>? route,
    bool? isTracking,
    int? currentStopIndex,
    List<bool>? deliveredStops,
    bool? isReturningToBase,
  }) => TripState(
    trip: trip ?? this.trip,
    driverLocation: driverLocation ?? this.driverLocation,
    route: route ?? this.route,
    isTracking: isTracking ?? this.isTracking,
    currentStopIndex: currentStopIndex ?? this.currentStopIndex,
    deliveredStops: deliveredStops ?? this.deliveredStops,
    isReturningToBase: isReturningToBase ?? this.isReturningToBase,
  );
}

// ── Cubit ─────────────────────────────────────────────────────────────────────

class TripCubit extends Cubit<TripState> {
  final TripRepository _tripRepo;

  Timer? _moveTimer;
  int _routeIndex = 0; // index into state.route for the current leg

  static const _stepMeters = 100.0;
  static const _moveInterval = Duration(seconds: 2);

  static const _mall = Location(lat: AppColors.mallLat, lng: AppColors.mallLng);

  TripCubit({required TripRepository tripRepo})
    : _tripRepo = tripRepo,
      super(TripState.initial());

  // ── Public API ─────────────────────────────────────────────────────────────

  /// [startLocation] is supplied by the caller so that the driver's position
  /// persists across trips instead of resetting to the GPS origin.
  Future<void> startTrip({
    required List<Order> orders,
    required Location startLocation,
  }) async {
    _moveTimer?.cancel();
    _moveTimer = null;

    final dest = Location(
      lat: orders.first.deliveryLat,
      lng: orders.first.deliveryLng,
    );

    final route = await _tripRepo.buildRoute(from: startLocation, to: dest);

    final trip = Trip(
      id: 'TRIP-${DateTime.now().millisecondsSinceEpoch}',
      orders: orders,
      status: TripStatus.started,
      destinationLat: dest.lat,
      destinationLng: dest.lng,
    );

    emit(state.copyWith(
      trip: trip,
      driverLocation: startLocation,
      route: route,
      isTracking: true,
      currentStopIndex: 0,
      deliveredStops: List.filled(orders.length, false),
    ));

    _startMovementSimulation(startLocation, dest);
  }

  /// Marks the current stop delivered.
  /// Advances to next stop, or routes back to the mall when all stops are done.
  Future<void> markCurrentDelivered() async {
    final trip = state.trip;
    if (trip == null) return;

    final idx = state.currentStopIndex;
    final updated = [...state.deliveredStops];
    updated[idx] = true;

    final from = state.driverLocation!;
    final nextIdx = idx + 1;

    if (nextIdx >= trip.orders.length) {
      // All deliveries done → route back to mall before finishing.
      final route = await _tripRepo.buildRoute(from: from, to: _mall);
      emit(state.copyWith(
        deliveredStops: updated,
        route: route,
        isTracking: true,
        isReturningToBase: true,
        trip: trip.copyWith(
          status: TripStatus.started,
          destinationLat: _mall.lat,
          destinationLng: _mall.lng,
        ),
      ));
      _startMovementSimulation(from, _mall);
      return;
    }

    final nextDest = Location(
      lat: trip.orders[nextIdx].deliveryLat,
      lng: trip.orders[nextIdx].deliveryLng,
    );

    final route = await _tripRepo.buildRoute(from: from, to: nextDest);

    emit(state.copyWith(
      deliveredStops: updated,
      currentStopIndex: nextIdx,
      route: route,
      isTracking: true,
      trip: trip.copyWith(
        status: TripStatus.started,
        destinationLat: nextDest.lat,
        destinationLng: nextDest.lng,
      ),
    ));

    _startMovementSimulation(from, nextDest);
  }

  Future<void> finishTrip() async {
    _moveTimer?.cancel();
    _moveTimer = null;
    emit(state.copyWith(
      isTracking: false,
      trip: state.trip?.copyWith(status: TripStatus.finished),
    ));
  }

  void resetTrip() {
    _moveTimer?.cancel();
    _moveTimer = null;
    emit(TripState.initial());
  }

  // ── Internal ───────────────────────────────────────────────────────────────

  /// Follows [state.route] waypoints one by one, consuming [_stepMeters] per
  /// tick. Advances through multiple close-together waypoints in a single tick
  /// so the speed is constant regardless of OSRM waypoint density.
  void _startMovementSimulation(Location startLoc, Location dest) {
    _moveTimer?.cancel();
    _routeIndex = 0;
    _moveTimer = Timer.periodic(_moveInterval, (_) {
      if (isClosed || !state.isTracking) return;

      final route = state.route;
      var pos = state.driverLocation ?? startLoc;
      var budget = _stepMeters; // metres still available this tick

      while (budget > 0) {
        final target = _routeIndex < route.length ? route[_routeIndex] : dest;

        final dx = target.lng - pos.lng;
        final dy = target.lat - pos.lat;
        // Approximate metres (1° ≈ 111 000 m)
        final dist = sqrt(dx * dx + dy * dy) * 111000;

        if (dist <= budget) {
          // Snap to this waypoint and use up the distance
          budget -= dist;
          pos = target;

          if (_routeIndex < route.length) {
            _routeIndex++; // advance to next waypoint
          } else {
            // Reached the final destination
            _moveTimer?.cancel();
            _moveTimer = null;
            emit(state.copyWith(
              driverLocation: dest,
              isTracking: false,
              trip: state.trip?.copyWith(status: TripStatus.arrived),
            ));
            return;
          }
        } else {
          // Move partway toward target and exhaust the budget
          final ratio = budget / dist;
          pos = Location(
            lat: pos.lat + dy * ratio,
            lng: pos.lng + dx * ratio,
          );
          budget = 0;
        }
      }

      emit(state.copyWith(driverLocation: pos));
    });
  }

  @override
  Future<void> close() {
    _moveTimer?.cancel();
    return super.close();
  }
}
