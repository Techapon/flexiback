import 'package:flexiback/features/auth/domain/repositories/auth_repository.dart';

import '../../../../shared/entities/role_enum.dart';
import '../../domain/entities/user_entity.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<UserEntity> login(String email, String password) {
    return remoteDataSource.login(email, password);
  }

  @override
  Future<UserEntity> signup(String email, String password, Role role) {
    return remoteDataSource.signup(email, password, role);
  }

}