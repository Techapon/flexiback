import 'package:flexiback/core/enums/role.dart';
import 'package:flexiback/features/profile/domain/entities/profile_entity.dart';
import 'package:flexiback/features/relation/data/datasources/relation_datasources.dart';
import 'package:flexiback/features/relation/data/repositories/relation_repository_impl.dart';
import 'package:flexiback/features/relation/domain/enums/relation_enums.dart';
import 'package:flexiback/features/relation/domain/usecases/delete_request_usecase.dart';
import 'package:flexiback/features/relation/domain/usecases/get_target_users_usecase.dart';
import 'package:flexiback/features/relation/domain/usecases/get_request_usecase.dart';
import 'package:flexiback/features/relation/domain/usecases/relation_request_usecase.dart';
import 'package:flexiback/features/relation/domain/entities/relation_reqeuest_entity.dart';
import 'package:flutter/material.dart';

class RelationProvider  extends ChangeNotifier {
  final getTargetUsersUsecase = 
    GetTargetUsersUsecase(RelationRepositoryImpl(RelationDatasources()));
  final getRequestUsecase = 
    GetRequestUsecase(RelationRepositoryImpl(RelationDatasources()));
  final relationRequestUsecase = 
    RelationRequestUsecase(RelationRepositoryImpl(RelationDatasources()));
  final deleteRequestUsecase = 
    DeleteRequestUsecase(RelationRepositoryImpl(RelationDatasources()));

  bool isLoading = false;
  bool isRequesting = false;
  String? error;

  List<ProfileEntity>? searchUsersList;
  List<RelationReqeuestEntity>? requestList;

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

  Future<void> sendRelationRequest(String targetUserId, Role requesterRole) async {
    error = null;

    isRequesting = true;
    notifyListeners();
    try {
      await relationRequestUsecase.call(targetUserId, requesterRole);
    } catch (e) {
      error = e.toString();
    }

    isRequesting = false;
    notifyListeners();
  }

  Future<void> getRequests() async {
    error = null;

    isLoading = true;
    notifyListeners();
    try {
      requestList = await getRequestUsecase.call();
    } catch (e) {
      error = e.toString();
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> deleteRequest(String requestId) async {
    error = null;

    notifyListeners();
    try {
      await deleteRequestUsecase.call(requestId);
    } catch (e) {
      error = e.toString();
    }

    notifyListeners();
  }



  // helper
  Relation getRelation(String userId) {
    if (isUserRequested(userId)) return Relation.request;
    // if ()
    return Relation.none;
  }

  // helper
  bool isUserRequested(String userId) {
    if (requestList == null) return false;
    return requestList!.any((request) => request.recipientId == userId);
  }
}