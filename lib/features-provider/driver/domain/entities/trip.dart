import 'order.dart';

enum TripStatus { ready, started, arrived, finished }

class Trip {
  final String id;
  final List<Order> orders;
  final TripStatus status;
  final double destinationLat;
  final double destinationLng;

  const Trip({
    required this.id,
    required this.orders,
    required this.status,
    required this.destinationLat,
    required this.destinationLng,
  });

  Trip copyWith({
    TripStatus? status,
    double? destinationLat,
    double? destinationLng,
    List<Order>? orders,
  }) {
    return Trip(
      id: id,
      orders: orders ?? this.orders,
      status: status ?? this.status,
      destinationLat: destinationLat ?? this.destinationLat,
      destinationLng: destinationLng ?? this.destinationLng,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'status': status.name,
    'destinationLat': destinationLat,
    'destinationLng': destinationLng,
    'orders': orders.map((o) => o.toJson()).toList(),
  };

  factory Trip.fromJson(Map<String, dynamic> json) => Trip(
    id: json['id'] as String,
    status: TripStatus.values.firstWhere(
      (s) => s.name == json['status'],
    ),
    destinationLat: (json['destinationLat'] as num).toDouble(),
    destinationLng: (json['destinationLng'] as num).toDouble(),
    orders: (json['orders'] as List)
        .map((o) => Order.fromJson(o as Map<String, dynamic>))
        .toList(),
  );
}
