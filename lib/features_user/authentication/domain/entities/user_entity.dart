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

  const UserEntity({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.password,
    required this.address,
    required this.latitude,
    required this.longitude,
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
  ];
}