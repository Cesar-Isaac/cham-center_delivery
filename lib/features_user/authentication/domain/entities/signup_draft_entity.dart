import 'package:equatable/equatable.dart';

class SignupDraftEntity extends Equatable {
  final String fullName;
  final String email;
  final String phone;
  final String password;

  /// خاصان بتسجيل السائق فقط.
  final String? vehicleType;
  final String? vehiclePlate;

  const SignupDraftEntity({
    required this.fullName,
    required this.email,
    required this.phone,
    required this.password,
    this.vehicleType,
    this.vehiclePlate,
  });

  @override
  List<Object?> get props => [
    fullName,
    email,
    phone,
    password,
    vehicleType,
    vehiclePlate,
  ];
}