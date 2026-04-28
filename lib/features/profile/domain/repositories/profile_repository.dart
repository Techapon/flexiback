import 'package:flexiback/core/entities/image_entity.dart';
import 'package:flexiback/core/enums/role.dart';

import '../entities/profile_entity.dart';

abstract class ProfileRepository {
  Future<ProfileEntity> getProfile();
  Future updateProfile(ProfileEntity newProfile, ImageEntity? newImage, String? oldImage);
  Future signOut();
}