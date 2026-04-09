import 'package:flexiback/features/profile/data/datasources/profile_remote_datasource.dart';
import 'package:flexiback/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:flexiback/features/profile/domain/entities/profile_entity.dart';
import 'package:flexiback/features/profile/domain/usecase/get_profile_usecase.dart';
import 'package:flutter/widgets.dart';

class ProfileProvider extends ChangeNotifier {
  final getProfileUsecase = 
      GetProfileUsecase(ProfileRepositoryImpl(ProfileRemoteDatasource()));

  bool isLoading  = false;
  String? errorr;
  ProfileEntity? profile;
 
  Future<void> getProfile() async {
    isLoading = true;
    notifyListeners();
    try {
      profile = await getProfileUsecase.call();
      errorr = null;
      print("----------------");
      print(profile);
    } catch (e) {
      errorr = e.toString();
      
    }

    isLoading = false;
    notifyListeners();
  }

}