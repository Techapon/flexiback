import 'package:flexiback/features/auth/domain/entities/user_entity.dart';

import '../../../../shared/entities/role_enum.dart';

abstract class AuthRepository {
  Future<UserEntity> login(String email, String password);
  Future<UserEntity> signup(String email, String password,Role role);
}