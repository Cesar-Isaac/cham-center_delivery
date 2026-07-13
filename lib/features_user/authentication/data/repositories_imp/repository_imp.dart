import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../data_sources/auth_local_data.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this.localDataSource);

  final AuthLocalDataSource localDataSource;

  @override
  Future<void> signup(UserEntity user) async {
    await localDataSource.saveUser(user);
  }

  @override
  Future<UserEntity?> login({
    required String email,
    required String password,
  }) async {
    final UserEntity? user = localDataSource.getUser();

    if (user == null) {
      return null;
    }

    final bool credentialsAreCorrect =
        user.email.trim().toLowerCase() ==
            email.trim().toLowerCase() &&
            user.password == password;

    if (!credentialsAreCorrect) {
      return null;
    }

    await localDataSource.setLoggedIn(true);

    return user;
  }

  @override
  Future<UserEntity?> getCurrentUser() async {
    if (!localDataSource.isLoggedIn) {
      return null;
    }

    return localDataSource.getUser();
  }

  @override
  Future<void> logout() async {
    await localDataSource.logout();
  }
}