class UserEntity {
  final String name;
  final String phone;
  final String address;
  final double latitude;
  final double longitude;

  const UserEntity({
    required this.name,
    required this.phone,
    required this.address,
    required this.latitude,
    required this.longitude,
  });

  bool get hasValidLocation {
    return latitude >= -90 &&
        latitude <= 90 &&
        longitude >= -180 &&
        longitude <= 180 &&
        !(latitude == 0 && longitude == 0);
  }
}