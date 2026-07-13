class DeliveryEntity {
  final String from;
  final String to;

  final double fromLatitude;
  final double fromLongitude;

  final double toLatitude;
  final double toLongitude;

  const DeliveryEntity({
    required this.from,
    required this.to,
    required this.fromLatitude,
    required this.fromLongitude,
    required this.toLatitude,
    required this.toLongitude,
  });
}