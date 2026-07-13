import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.fullName,
    required super.email,
    required super.phone,
    required super.password,
    required super.address,
    required super.latitude,
    required super.longitude,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: (json['id'] as num).toInt(),
      fullName: json['fullName'] as String? ?? '',
      email: json['email'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      password: json['password'] as String? ?? '',
      address: json['address'] as String? ?? '',
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
    );
  }

  factory UserModel.fromEntity(UserEntity user) {
    return UserModel(
      id: user.id,
      fullName: user.fullName,
      email: user.email,
      phone: user.phone,
      password: user.password,
      address: user.address,
      latitude: user.latitude,
      longitude: user.longitude,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'email': email,
      'phone': phone,
      'password': password,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  @override
  UserModel copyWith({
    int? id,
    String? fullName,
    String? email,
    String? phone,
    String? password,
    String? address,
    double? latitude,
    double? longitude,
  }) {
    return UserModel(
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
}