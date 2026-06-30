import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../../../../core/style/repo/app_colors.dart';
import '../../../../../core/style/widgets/app_tile_layer.dart';
import '../../../domain/entities/trip.dart';
import '../../state/trip/trip_cubit.dart';
import '../../widgets/order_info_card.dart';

class TripScreen extends StatefulWidget {
  const TripScreen({super.key});

  static const route = '/trip';

  @override
  State<TripScreen> createState() => _TripScreenState();
}

class _TripScreenState extends State<TripScreen> {
  final MapController _mapController = MapController();
  bool _mapReady = false;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TripCubit, TripState>(
      listenWhen: (prev, curr) {
        final locChanged = prev.driverLocation != curr.driverLocation;
        final finished =
            curr.trip?.status == TripStatus.finished &&
            prev.trip?.status != TripStatus.finished;
        final stopAdvanced = prev.currentStopIndex != curr.currentStopIndex;
        return locChanged || finished || stopAdvanced;
      },
      listener: (ctx, state) {
        if (state.trip?.status == TripStatus.finished) {
          Navigator.of(ctx).pop();
          return;
        }
        if (_mapReady && state.driverLocation != null) {
          _mapController.move(
            LatLng(state.driverLocation!.lat, state.driverLocation!.lng),
            _mapController.camera.zoom,
          );
        }
      },
      builder: (context, state) {
        final trip = state.trip;

        if (trip == null) {
          return const Scaffold(
            backgroundColor: Color(0xFF0B1220),
            body: Center(
              child: CircularProgressIndicator(color: Colors.teal),
            ),
          );
        }

        final driverLoc = state.driverLocation;
        final currentDest = LatLng(trip.destinationLat, trip.destinationLng);
        final arrived = trip.status == TripStatus.arrived;
        final isLastStop =
            state.currentStopIndex >= trip.orders.length - 1;
        final isReturningToBase = state.isReturningToBase;

        final routePoints = state.route
            .map((l) => LatLng(l.lat, l.lng))
            .toList();

        final initialCenter = driverLoc != null
            ? LatLng(driverLoc.lat, driverLoc.lng)
            : currentDest;

        return Scaffold(
          backgroundColor: const Color(0xFF0B1220),
          body: Stack(
            children: [
              // ── Map ─────────────────────────────────────────────────────
              Positioned.fill(
                child: FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    initialCenter: initialCenter,
                    initialZoom: 15,
                    onMapReady: () => setState(() => _mapReady = true),
                  ),
                  children: [
                    const AppTileLayer(),

                    // Route polyline
                    if (routePoints.isNotEmpty)
                      PolylineLayer(
                        polylines: [
                          Polyline(
                            points: routePoints,
                            color: Colors.teal,
                            strokeWidth: 4,
                          ),
                        ],
                      ),

                    // Destination markers — one per stop, color-coded
                    MarkerLayer(
                      markers: [
                        for (int i = 0; i < trip.orders.length; i++)
                          Marker(
                            point: LatLng(
                              trip.orders[i].deliveryLat,
                              trip.orders[i].deliveryLng,
                            ),
                            width: 48,
                            height: 56,
                            child: _DestinationPin(
                              isDelivered: i < state.deliveredStops.length &&
                                  state.deliveredStops[i],
                              isCurrent: i == state.currentStopIndex &&
                                  !isReturningToBase,
                            ),
                          ),
                        // Mall marker — shown while returning to base
                        if (isReturningToBase)
                          Marker(
                            point: LatLng(
                              AppColors.mallLat,
                              AppColors.mallLng,
                            ),
                            width: 48,
                            height: 56,
                            child: _MallPin(arrived: arrived),
                          ),
                        if (driverLoc != null)
                          Marker(
                            point: LatLng(driverLoc.lat, driverLoc.lng),
                            width: 44,
                            height: 44,
                            child: _DriverPin(arrived: arrived),
                          ),
                      ],
                    ),
                  ],
                ),
              ),

              // ── Top bar ─────────────────────────────────────────────────
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: _TripAppBar(
                  tripId: trip.id,
                  status: trip.status,
                  orderCount: trip.orders.length,
                  isReturningToBase: isReturningToBase,
                ),
              ),

              // ── Bottom panel ─────────────────────────────────────────────
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: _BottomPanel(
                  trip: trip,
                  arrived: arrived,
                  isLastStop: isLastStop,
                  isReturningToBase: isReturningToBase,
                  currentStopIndex: state.currentStopIndex,
                  deliveredStops: state.deliveredStops,
                  onDeliverStop: () =>
                      context.read<TripCubit>().markCurrentDelivered(),
                  onFinishTrip: () =>
                      context.read<TripCubit>().finishTrip(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ── Marker widgets ─────────────────────────────────────────────────────────────

class _DestinationPin extends StatelessWidget {
  const _DestinationPin({
    required this.isCurrent,
    required this.isDelivered,
  });
  final bool isCurrent;
  final bool isDelivered;

  @override
  Widget build(BuildContext context) {
    final Color color = isDelivered
        ? AppColors.markerDelivered
        : isCurrent
            ? AppColors.markerDestCurrent
            : AppColors.markerDestPending;
    final IconData icon = isDelivered ? Icons.check : Icons.flag;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.4),
                blurRadius: 8,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Icon(icon, color: Colors.white, size: 16),
        ),
        Container(
          width: 3,
          height: 14,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
      ],
    );
  }
}

class _DriverPin extends StatelessWidget {
  const _DriverPin({required this.arrived});
  final bool arrived;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: arrived ? Colors.green : Colors.teal,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: [
          BoxShadow(
            color: (arrived ? Colors.green : Colors.teal).withValues(alpha: 0.5),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Icon(
        arrived ? Icons.check : Icons.directions_car,
        color: Colors.white,
        size: 22,
      ),
    );
  }
}

class _MallPin extends StatelessWidget {
  const _MallPin({required this.arrived});
  final bool arrived;

  @override
  Widget build(BuildContext context) {
    final color = arrived ? Colors.green : Colors.orange;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.4),
                blurRadius: 8,
                spreadRadius: 2,
              ),
            ],
          ),
          child: const Icon(Icons.store, color: Colors.white, size: 16),
        ),
        Container(
          width: 3,
          height: 14,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
      ],
    );
  }
}

// ── Top app bar ────────────────────────────────────────────────────────────────

class _TripAppBar extends StatelessWidget {
  const _TripAppBar({
    required this.tripId,
    required this.status,
    required this.orderCount,
    required this.isReturningToBase,
  });
  final String tripId;
  final TripStatus status;
  final int orderCount;
  final bool isReturningToBase;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 8,
        left: 12,
        right: 12,
        bottom: 12,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF0B1220).withValues(alpha: 0.92),
        border: Border(
          bottom: BorderSide(
            color: Colors.white.withValues(alpha: 0.06),
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isReturningToBase ? 'العودة إلى المول' : 'رحلة جارية',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 15,
                  ),
                ),
                Text(
                  isReturningToBase
                      ? AppColors.mallAddress
                      : '$orderCount ${orderCount == 1 ? 'طلب' : 'طلبات'}',
                  style: const TextStyle(color: Colors.white38, fontSize: 12),
                ),
              ],
            ),
          ),
          _StatusChip(status: status, isReturningToBase: isReturningToBase),
        ],
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status, required this.isReturningToBase});
  final TripStatus status;
  final bool isReturningToBase;

  @override
  Widget build(BuildContext context) {
    final (label, color) = switch (status) {
      TripStatus.ready => ('جاهز', Colors.white38),
      TripStatus.started => isReturningToBase
          ? ('العودة للمول', Colors.orange)
          : ('جاري التوصيل', Colors.teal),
      TripStatus.arrived => isReturningToBase
          ? ('وصلت للمول!', Colors.green)
          : ('وصلت!', Colors.green),
      TripStatus.finished => ('منتهية', Colors.white38),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

// ── Bottom panel ───────────────────────────────────────────────────────────────

class _BottomPanel extends StatelessWidget {
  const _BottomPanel({
    required this.trip,
    required this.arrived,
    required this.isLastStop,
    required this.isReturningToBase,
    required this.currentStopIndex,
    required this.deliveredStops,
    required this.onDeliverStop,
    required this.onFinishTrip,
  });
  final Trip trip;
  final bool arrived;
  final bool isLastStop;
  final bool isReturningToBase;
  final int currentStopIndex;
  final List<bool> deliveredStops;
  final VoidCallback onDeliverStop;
  final VoidCallback onFinishTrip;

  @override
  Widget build(BuildContext context) {
    final currentOrder = trip.orders[currentStopIndex];

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF0F1923),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.5),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 4),
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),

            // Stop progress indicator (only for multi-stop trips)
            if (trip.orders.length > 1)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
                child: Row(
                  children: [
                    const Icon(
                      Icons.route_outlined,
                      color: Colors.teal,
                      size: 14,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'محطة ${currentStopIndex + 1} من ${trip.orders.length}',
                      style: const TextStyle(
                        color: Colors.teal,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),

            // Order cards (scrollable if multiple)
            ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.32,
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: Column(
                  children: trip.orders.indexed
                      .map(
                        (entry) => OrderInfoCard(
                          order: entry.$2,
                          index: entry.$1,
                          isDelivered: entry.$1 < deliveredStops.length &&
                              deliveredStops[entry.$1],
                        ),
                      )
                      .toList(),
                ),
              ),
            ),

            // Action button / navigation hint
            if (isReturningToBase && arrived)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade700,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    onPressed: onFinishTrip,
                    icon: const Icon(Icons.home_outlined, size: 22),
                    label: const Text(
                      'تم الوصول إلى شام سنتر — إنهاء العمل',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
                    ),
                  ),
                ),
              )
            else if (isReturningToBase)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
                child: Row(
                  children: [
                    const Icon(Icons.store_outlined, color: Colors.orange, size: 16),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text(
                        'في طريقك إلى شام سنتر، كفرسوسة',
                        style: TextStyle(color: Colors.white54, fontSize: 12),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              )
            else if (arrived)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isLastStop
                          ? Colors.teal.shade700
                          : AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    onPressed: onDeliverStop,
                    icon: Icon(
                      isLastStop
                          ? Icons.directions_outlined
                          : Icons.navigate_next,
                      size: 22,
                    ),
                    label: Text(
                      isLastStop
                          ? 'تم التسليم — العودة للمول'
                          : 'تم التسليم — الانتقال للطلب التالي',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
              )
            else
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
                child: Row(
                  children: [
                    const Icon(
                      Icons.navigation_outlined,
                      color: Colors.teal,
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'في طريقك إلى ${currentOrder.deliveryAddress}',
                        style: const TextStyle(
                          color: Colors.white54,
                          fontSize: 12,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
