import 'package:flexiback/features/auth/domain/entities/user_entity.dart';
import 'package:flexiback/features/auth/domain/repositories/auth_repository.dart';
class SignupUseCase {
  final AuthRepository repo;

  SignupUseCase(this.repo);

  Future<UserEntity> call(String emial, String password) {
    return repo.signup(emial, password);
  }

}