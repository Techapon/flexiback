import 'package:flexiback/features/auth/domain/entities/user_entity.dart';

import '../../../identity/domain/enums/role.dart';

abstract class AuthRepository {
  Future<UserEntity> login(String email, String password);
  Future<UserEntity> signup(String email, String password,Role role);
}