import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/user_entity.dart';

class AuthLocalDataSource {
  AuthLocalDataSource(this.prefs);

  final SharedPreferences prefs;

  static const String _userKey = 'registered_user';
  static const String _sessionKey = 'user_logged_in';

  Future<void> saveUser(UserEntity user) async {
    final Map<String, dynamic> json = {
      'id': user.id,
      'fullName': user.fullName,
      'email': user.email,
      'phone': user.phone,
      'password': user.password,
      'address': user.address,
      'latitude': user.latitude,
      'longitude': user.longitude,
    };

    await prefs.setString(
      _userKey,
      jsonEncode(json),
    );

    // بعد إنشاء الحساب نطلب من المستخدم تسجيل الدخول.
    await prefs.setBool(_sessionKey, false);
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