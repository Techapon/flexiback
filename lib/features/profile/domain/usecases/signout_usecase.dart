import 'package:flexiback/features/profile/domain/repositories/profile_repository.dart';

class SignoutUsecase {
  final ProfileRepository repo;

  SignoutUsecase(this.repo);

  Future<void> call() {
    return repo.signOut();
  }
}