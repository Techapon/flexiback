import 'package:flexiback/features/profile/domain/entities/profile_entity.dart';
import 'package:flexiback/features/profile/domain/repositories/profile_repository.dart';
import 'package:flexiback/shared/entities/image_entity.dart';

class UpdateProfileUsecase {
  final ProfileRepository repo;
  
  UpdateProfileUsecase(this.repo);

  Future call(
    ProfileEntity newProfile,
    ImageEntity newImage,
    String oldImage
  ) {
    return repo.updateProfile(
      newProfile,
      newImage,
      oldImage
    );
  }
}