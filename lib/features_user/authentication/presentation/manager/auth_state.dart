import 'package:equatable/equatable.dart';

import '../../domain/entities/user_entity.dart';

enum AuthStatus {
  initial,
  loading,
  locationUpdated,
  signupSuccess,
  authenticated,
  unauthenticated,
  profileUpdated,
  failure,
}

class AuthState extends Equatable {
  final AuthStatus status;
  final UserEntity? user;
  final String errorMessage;
  final String address;
  final double latitude;
  final double longitude;

  const AuthState({
    this.status = AuthStatus.initial,
    this.user,
    this.errorMessage = '',
    this.address = '',
    this.latitude = 0,
    this.longitude = 0,
  });

  AuthState copyWith({
    AuthStatus? status,
    UserEntity? user,
    String? errorMessage,
    String? address,
    double? latitude,
    double? longitude,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      errorMessage: errorMessage ?? this.errorMessage,
      address: address ?? this.address,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }

  @override
  List<Object?> get props => [
    status,
    user,
    errorMessage,
    address,
    latitude,
    longitude,
  ];
}