import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/user_entity.dart';

class AuthLocalDataSource {
  /// مفاتيح التخزين قابلة للتخصيص حتى يكون حساب السائق
  /// منفصلاً تماماً عن حساب المستخدم.
  AuthLocalDataSource(
      this.prefs, {
        String userKey = 'registered_user',
        String sessionKey = 'user_logged_in',
      })  : _userKey = userKey,
        _sessionKey = sessionKey;

  final SharedPreferences prefs;

  final String _userKey;
  final String _sessionKey;

  Future<void> saveUser(UserEntity user) async {
    await _writeUser(user);

    // بعد إنشاء الحساب نطلب من المستخدم تسجيل الدخول.
    await prefs.setBool(_sessionKey, false);
  }

  /// تحديث بيانات الحساب دون إنهاء الجلسة الحالية.
  Future<void> updateUser(UserEntity user) async {
    await _writeUser(user);
  }

  Future<void> _writeUser(UserEntity user) async {
    final Map<String, dynamic> json = {
      'id': user.id,
      'fullName': user.fullName,
      'email': user.email,
      'phone': user.phone,
      'password': user.password,
      'address': user.address,
      'latitude': user.latitude,
      'longitude': user.longitude,
      'vehicleType': user.vehicleType,
      'vehiclePlate': user.vehiclePlate,
    };

    await prefs.setString(
      _userKey,
      jsonEncode(json),
    );
  }

  UserEntity? getUser() {
    final String? encodedUser = prefs.getString(_userKey);

    if (encodedUser == null || encodedUser.isEmpty) {
      return null;
    }

    try {
      final Map<String, dynamic> json =
      jsonDecode(encodedUser) as Map<String, dynamic>;

      return UserEntity(
        id: (json['id'] as num).toInt(),
        fullName: json['fullName'] as String,
        email: json['email'] as String,
        phone: json['phone'] as String,
        password: json['password'] as String,
        address: json['address'] as String,
        latitude: (json['latitude'] as num).toDouble(),
        longitude: (json['longitude'] as num).toDouble(),
        vehicleType: json['vehicleType'] as String?,
        vehiclePlate: json['vehiclePlate'] as String?,
      );
    } catch (_) {
      return null;
    }
  }

  bool get isLoggedIn {
    return prefs.getBool(_sessionKey) ?? false;
  }

  Future<void> setLoggedIn(bool value) async {
    await prefs.setBool(_sessionKey, value);
  }

  Future<void> logout() async {
    // لا نحذف الحساب، فقط ننهي الجلسة.
    await prefs.setBool(_sessionKey, false);
  }
}