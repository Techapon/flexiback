import 'package:flexiback/features/auth/domain/entities/user_entity.dart';
import 'package:flexiback/features/auth/domain/repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository repo;

  LoginUseCase(this.repo);

  Future<UserEntity> call(String emial, String password) {
    return repo.login(emial, password);
  }

}