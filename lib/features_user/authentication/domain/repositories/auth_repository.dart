import '../entities/user_entity.dart';

abstract class AuthRepository {
  Future<void> signup(UserEntity user);

  Future<UserEntity?> login({
    required String email,
    required String password,
  });

  Future<UserEntity?> getCurrentUser();

  Future<void> logout();
}