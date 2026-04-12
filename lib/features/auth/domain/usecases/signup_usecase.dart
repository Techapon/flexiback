import 'package:flexiback/features/auth/domain/entities/user_entity.dart';
import 'package:flexiback/features/auth/domain/repositories/auth_repository.dart';

import '../../../../shared/entities/role_enum.dart';
class SignupUseCase {
  final AuthRepository repo;

  SignupUseCase(this.repo);

  Future<UserEntity> call(String emial, String password,Role role) {
    return repo.signup(emial, password,role);
  }

}