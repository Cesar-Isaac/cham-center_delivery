import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class UpdateUserUseCase {
  UpdateUserUseCase(this.repository);

  final AuthRepository repository;

  Future<void> call(UserEntity user) {
    return repository.updateUser(user);
  }
}
