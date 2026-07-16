import '../entities/user_entity.dart';

abstract class AuthRepository {
  Future<void> signup(UserEntity user);

  /// هل البريد الإلكتروني مستخدم من حساب مسجّل سابقاً؟
  bool isEmailTaken(String email);

  /// هل رقم الهاتف مستخدم من حساب مسجّل سابقاً؟
  bool isPhoneTaken(String phone);

  Future<UserEntity?> login({
    required String email,
    required String password,
  });

  Future<UserEntity?> getCurrentUser();

  Future<void> updateUser(UserEntity user);

  Future<void> logout();
}