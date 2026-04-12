import 'package:flexiback/shared/entities/image_entity.dart';

import '../entities/general_entity.dart';
import '../entities/profile_entity.dart';

abstract class ProfileRepository {
  Future<ProfileEntity> getProfile();
  Future updateProfile(ProfileEntity newProfile, ImageEntity newImage, String oldImage);
}