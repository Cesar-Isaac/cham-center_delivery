import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../data_sources/auth_local_data.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this.localDataSource);

  final AuthLocalDataSource localDataSource;

  @override
  Future<void> signup(UserEntity user) async {
    // حماية أخيرة: لا يُنشأ حساب ببريد أو هاتف مستخدمين من قبل.
    final bool emailTaken = isEmailTaken(user.email);
    final bool phoneTaken = isPhoneTaken(user.phone);

    if (emailTaken && phoneTaken) {
      throw Exception(
        'البريد الإلكتروني ورقم الهاتف مستخدمان من قبل.',
      );
    }

    if (emailTaken) {
      throw Exception(
        'البريد الإلكتروني مستخدم من قبل.',
      );
    }

    if (phoneTaken) {
      throw Exception(
        'رقم الهاتف مستخدم من قبل.',
      );
    }

    await localDataSource.saveUser(user);
  }

  @override
  bool isEmailTaken(String email) {
    final UserEntity? existing = localDataSource.getUser();

    if (existing == null) return false;

    return existing.email.trim().toLowerCase() ==
        email.trim().toLowerCase();
  }

  @override
  bool isPhoneTaken(String phone) {
    final UserEntity? existing = localDataSource.getUser();

    if (existing == null) return false;

    return _normalizePhone(existing.phone) ==
        _normalizePhone(phone);
  }

  String _normalizePhone(String phone) {
    return phone.replaceAll(RegExp(r'[\s\-()]'), '');
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
  Future<void> updateUser(UserEntity user) async {
    await localDataSource.updateUser(user);
  }

  @override
  Future<void> logout() async {
    await localDataSource.logout();
  }
}