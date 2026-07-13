import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../domain/entities/route_point_entity.dart';

class TrackingMap extends StatelessWidget {
  final List<RoutePointEntity> routePoints;
  final RoutePointEntity driverLocation;
  final RoutePointEntity startLocation;
  final RoutePointEntity endLocation;

  const TrackingMap({
    super.key,
    required this.routePoints,
    required this.driverLocation,
    required this.startLocation,
    required this.endLocation,
  });

  @override
  Widget build(BuildContext context) {
    final mapRoutePoints = routePoints
        .map(
          (point) => LatLng(
        point.latitude,
        point.longitude,
      ),
    )
        .toList();

    return FlutterMap(
      options: MapOptions(
        initialCenter: LatLng(
          driverLocation.latitude,
          driverLocation.longitude,
        ),
        initialZoom: 14,
        minZoom: 4,
        maxZoom: 18,
      ),
      children: [
        TileLayer(
          urlTemplate:
          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName:
          'com.example.tracking_provider',
        ),

        PolylineLayer(
          polylines: [
            Polyline(
              points: mapRoutePoints,
              strokeWidth: 5,
              color: Colors.blue,
            ),
          ],
        ),

        MarkerLayer(
          markers: [
            Marker(
              point: LatLng(
                startLocation.latitude,
                startLocation.longitude,
              ),
              width: 52,
              height: 52,
              child: const _MapMarker(
                icon: Icons.store,
                color: Colors.orange,
              ),
            ),
            Marker(
              point: LatLng(
                endLocation.latitude,
                endLocation.longitude,
              ),
              width: 52,
              height: 52,
              child: const _MapMarker(
                icon: Icons.location_on,
                color: Colors.red,
              ),
            ),
            Marker(
              point: LatLng(
                driverLocation.latitude,
                driverLocation.longitude,
              ),
              width: 52,
              height: 52,
              child: const _MapMarker(
                icon: Icons.delivery_dining,
                color: Colors.blue,
              ),
            ),
          ],
        ),

        const RichAttributionWidget(
          attributions: [
            TextSourceAttribution(
              '© OpenStreetMap contributors',
            ),
          ],
        ),
      ],
    );
  }
}

class _MapMarker extends StatelessWidget {
  final IconData icon;
  final Color color;

  const _MapMarker({
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 6,
          ),
        ],
        border: Border.all(
          color: color,
          width: 2,
        ),
      ),
      child: Icon(
        icon,
        color: color,
        size: 30,
      ),
    );
  }
}