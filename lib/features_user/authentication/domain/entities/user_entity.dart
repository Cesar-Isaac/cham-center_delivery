import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final int id;
  final String fullName;
  final String email;
  final String phone;
  final String password;
  final String address;
  final double latitude;
  final double longitude;

  /// خاصان بحساب السائق فقط، ويبقيان null لحساب المستخدم.
  final String? vehicleType;
  final String? vehiclePlate;

  const UserEntity({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.password,
    required this.address,
    required this.latitude,
    required this.longitude,
    this.vehicleType,
    this.vehiclePlate,
  });

  UserEntity copyWith({
    int? id,
    String? fullName,
    String? email,
    String? phone,
    String? password,
    String? address,
    double? latitude,
    double? longitude,
    String? vehicleType,
    String? vehiclePlate,
  }) {
    return UserEntity(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      password: password ?? this.password,
      address: address ?? this.address,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      vehicleType: vehicleType ?? this.vehicleType,
      vehiclePlate: vehiclePlate ?? this.vehiclePlate,
    );
  }

  @override
  List<Object?> get props => [
    id,
    fullName,
    email,
    phone,
    password,
    address,
    latitude,
    longitude,
    vehicleType,
    vehiclePlate,
  ];
}