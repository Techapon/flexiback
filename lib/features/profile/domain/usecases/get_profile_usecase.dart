import '../repositories/profile_repository.dart';
import '../entities/profile_entity.dart';

class GetProfileUsecase {
  final ProfileRepository repo;

  GetProfileUsecase(this.repo);

  Future<ProfileEntity> call() {
    return repo.getProfile();
  }
}