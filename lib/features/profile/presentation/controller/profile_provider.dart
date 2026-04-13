import 'package:flexiback/features/profile/data/datasources/profile_remote_datasource.dart';
import 'package:flexiback/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:flexiback/features/profile/domain/entities/general_entity.dart';
import 'package:flexiback/features/profile/domain/entities/profile_entity.dart';
import 'package:flexiback/features/profile/domain/usecase/get_profile_usecase.dart';
import 'package:flexiback/shared/entities/image_entity.dart';
import 'package:flutter/widgets.dart';

import '../../../../shared/entities/role_enum.dart';
import '../../../../shared/utils/get_role.dart';
import '../../domain/entities/therapist_entity.dart';
import '../../domain/usecase/update_profile_usecase.dart';

class ProfileProvider extends ChangeNotifier {
  final getProfileUsecase = 
      GetProfileUsecase(ProfileRepositoryImpl(ProfileRemoteDatasource()));
  final updateProfileUsecase =
      UpdateProfileUsecase(ProfileRepositoryImpl(ProfileRemoteDatasource()));

  bool isLoading  = false;
  String? error;
  ProfileEntity? profile;

  // Getter 
  Role get role => getRole(profile!.role);
  
  // ----- Therapist Getter -----
  String get specialty {
    if (role == Role.Therapist) {
      return (profile as TherapistEntity).specialty ?? "Not specified";
    }
    return "-";
  }

  String get affiliation {
    if (role == Role.Therapist) {
      return (profile as TherapistEntity).affiliation ?? "Not specified";
    }
    return "-";
  }

  String get institution {
    if (role == Role.Therapist) {
      return (profile as TherapistEntity).institution ?? "Not specified";
    }
    return "-";
  }

  String get experience {
    if (role == Role.Therapist) {
      return (profile as TherapistEntity).experience ?? "Not specified";
    }
    return "-";
  }

  // ----- General Getter -----
  String get weight {
    if (role == Role.General) {
      final String? weight  = (profile as GeneralEntity).weight.toString();
      return weight ?? "-";
    }
    return "-";
  }

  String get height {
    if (role == Role.General) {
      final String? height  = (profile as GeneralEntity).height.toString();
      return height ?? "-";
    }
    return "-";
  }

  String get pmh {
    if (role == Role.General) {
      final String? pmh  = (profile as GeneralEntity).pmh.toString();
      return pmh ?? "-";
    }
    return "-";
  }

  // ----- Call -----
 
  Future<void> getProfile() async {
    isLoading = true;
    notifyListeners();
    try {
      profile = await getProfileUsecase.call();
      error = null;

      print(profile.toString());
    } catch (e) {
      error = e.toString();
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> updateProfile(
    ProfileEntity newProifle,
    ImageEntity? imageFile,
  ) async {
    isLoading = true;
    notifyListeners();

    try {
      await updateProfileUsecase.call(
          newProifle,
          imageFile, 
          profile?.img
        );
      
      profile = await getProfileUsecase.call();

      error = null;
    }catch (e) {
      error = e.toString();
    }

    isLoading = false;
    notifyListeners();
  }

}