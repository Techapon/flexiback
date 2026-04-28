import 'package:flexiback/core/enums/role.dart';
import 'package:flexiback/features/profile/domain/entities/profile_entity.dart';
import 'package:flexiback/features/relation/data/datasources/relation_datasources.dart';
import 'package:flexiback/features/relation/data/repositories/relation_repository_impl.dart';
import 'package:flexiback/features/relation/domain/usecases/get_target_users_usecase.dart';
import 'package:flutter/material.dart';

class RelationProvider  extends ChangeNotifier {
  final getTargetUsersUsecase = 
    GetTargetUsersUsecase(RelationRepositoryImpl(RelationDatasources()));

  bool isLoading = false;
  String? error;

  List<ProfileEntity>? searchUsersList;

  Future<void> searchUsers(Role targetRole) async {
    error = null;

    isLoading = true;
    notifyListeners();
    try {
      searchUsersList = await getTargetUsersUsecase.call(targetRole);
    } catch (e) {
      error = e.toString();
    }

    isLoading = false;
    notifyListeners();
  }
}