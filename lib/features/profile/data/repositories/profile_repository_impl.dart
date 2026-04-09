
import '../../domain/entities/profile_entity.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_remote_datasource.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDatasource profileRemoteDatasource;

  ProfileRepositoryImpl(this.profileRemoteDatasource);

  @override
  Future<ProfileEntity> getProfile() {
    return profileRemoteDatasource.getProfile();
  }
}