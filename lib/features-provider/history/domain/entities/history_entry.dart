import '../../../driver/domain/entities/trip.dart';

class HistoryEntry {
  final Trip trip;
  final DateTime completedAt;

  const HistoryEntry({required this.trip, required this.completedAt});

  double get totalPrice =>
      trip.orders.fold(0.0, (sum, o) => sum + o.price);

  Map<String, dynamic> toJson() => {
    'completedAt': completedAt.toIso8601String(),
    'trip': trip.toJson(),
  };

  factory HistoryEntry.fromJson(Map<String, dynamic> json) => HistoryEntry(
    completedAt: DateTime.parse(json['completedAt'] as String),
    trip: Trip.fromJson(json['trip'] as Map<String, dynamic>),
  );
}
