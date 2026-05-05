import 'dart:async';
import 'package:flexiback/core/enums/role.dart';
import 'package:flexiback/features/profile/data/datasources/profile_remote_datasource.dart';
import 'package:flexiback/features/profile/domain/entities/profile_entity.dart';
import 'package:flexiback/features/relation/data/datasources/relation_datasources.dart';
import 'package:flexiback/features/relation/data/repositories/relation_repository_impl.dart';
import 'package:flexiback/features/relation/domain/entities/message_entity.dart';
import 'package:flexiback/features/relation/domain/entities/relation_entity.dart';
import 'package:flexiback/features/relation/domain/enums/relation_enums.dart';
import 'package:flexiback/features/relation/domain/usecases/accept_request_usecase.dart';
import 'package:flexiback/features/relation/domain/usecases/delete_relation_usecase.dart';
import 'package:flexiback/features/relation/domain/usecases/delete_request_usecase.dart';
import 'package:flexiback/features/relation/domain/usecases/get_chat_usecase.dart';
import 'package:flexiback/features/relation/domain/usecases/get_relations_usecase.dart';
import 'package:flexiback/features/relation/domain/usecases/get_target_users_usecase.dart';
import 'package:flexiback/features/relation/domain/usecases/get_request_usecase.dart';
import 'package:flexiback/features/relation/domain/usecases/get_income_request_usecase.dart';
import 'package:flexiback/features/relation/domain/usecases/relation_request_usecase.dart';
import 'package:flexiback/features/relation/domain/usecases/send_message_usecase.dart';
import 'package:flexiback/features/relation/domain/entities/relation_reqeuest_entity.dart';
import 'package:flutter/material.dart';

import '../../domain/usecases/get_income_request_usecase.dart';

class RelationProvider  extends ChangeNotifier {
  final getTargetUsersUsecase = 
    GetTargetUsersUsecase(RelationRepositoryImpl(
      RelationDatasources(),
      ProfileRemoteDatasource()
    ));

  final getRequestUsecase = 
    GetRequestUsecase(RelationRepositoryImpl(
      RelationDatasources(),
      ProfileRemoteDatasource()
    ));
  final getIncomeRequestUsecase = 
    GetIncomeRequestUsecase(RelationRepositoryImpl(
      RelationDatasources(),
      ProfileRemoteDatasource()
    ));
  
  final relationRequestUsecase = 
    RelationRequestUsecase(RelationRepositoryImpl(
      RelationDatasources(),
      ProfileRemoteDatasource()
    ));
  final deleteRequestUsecase = 
    DeleteRequestUsecase(RelationRepositoryImpl(
      RelationDatasources(),
      ProfileRemoteDatasource()
    ));
  final acceptRequestUsecase =
    AcceptRequestUsecase(RelationRepositoryImpl(
      RelationDatasources(),
      ProfileRemoteDatasource()
    ));

  final deleteRelationUsecase =
    DeleteRelationUsecase(RelationRepositoryImpl(
      RelationDatasources(),
      ProfileRemoteDatasource()
    ));

  final getRelationsUsecase =
    GetRelationsUsecase(RelationRepositoryImpl(
      RelationDatasources(),
      ProfileRemoteDatasource()
    ));

  final getChatUsecase =
    GetChatUsecase(RelationRepositoryImpl(
      RelationDatasources(),
      ProfileRemoteDatasource()
    ));

  final sendMessageUsecase =
    SendMessageUsecase(RelationRepositoryImpl(
      RelationDatasources(),
      ProfileRemoteDatasource()
    ));
  
  // Relation
  StreamSubscription<List<RelationEntity>>? _relationsSubscription;
  List<RelationEntity>? relations;
  
  void clearRelations() {
    _relationsSubscription?.cancel();
    relations = null;
  }

  // Chat
  Stream<List<MessageEntity>>? _chatStream;
  Stream<List<MessageEntity>>? get chatStream => _chatStream;

  void clearChat() {
    _chatStream = null;
  }

  void clearRequest() {
    searchUsersList = null;
    requestList = null;
    incomeList = null;
  }

  bool isLoading = false;
  bool isRequesting = false;
  String? error;

  List<ProfileEntity>? searchUsersList;
  List<RelationReqeuestEntity>? requestList;
  List<RelationReqeuestEntity>? incomeList;
  

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

  // get request
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

  Future<void> getIncomeRequests() async {
    error = null;

    isLoading = true;
    notifyListeners();
    try {
      incomeList = await getIncomeRequestUsecase.call();
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

  Future<void> acceptRequest(RelationReqeuestEntity request) async {
    error = null;

    notifyListeners();
    try {
      await acceptRequestUsecase.call(request);
    } catch (e) {
      error = e.toString();
    }

    notifyListeners();
  }

  Future<void> getRelations(Role targetUser) async {
    error = null;
    try {
      _relationsSubscription?.cancel();
      _relationsSubscription = getRelationsUsecase.call(targetUser).listen((data) {
        print("Provider init");
        relations = data;
        notifyListeners();
      });
    } catch (e) {
      error = e.toString();
    }
  }

  Future<void> deleteRelation(String relationId) async {
    error = null;
    notifyListeners();
    try {
      await deleteRelationUsecase.call(relationId);
    } catch (e) {
      error = e.toString();
    }
    notifyListeners();
  }

  // Chat
  Future<void> getChat(String targetUser) async {
    error = null; 
    try {
      _chatStream = getChatUsecase.call(targetUser);
    } catch (e) {
      error = e.toString();
      _chatStream = null;
    }
  }

  Future<void> sendMessage(MessageEntity message) async {
    error = null;
    try {
      await sendMessageUsecase.call(message);
      notifyListeners();
    } catch (e) {
      error = e.toString();
    }
  }

  // helper
  Relation getRelation(String userId) {
    if (isFriend(userId)) return Relation.freind;
    if (isUserRequested(userId)) return Relation.requested;
    if (isUserReceived(userId)) return Relation.received;
    return Relation.none;
  }

  bool isFriend(String userId) {
    if (relations == null) return false;
    return relations!.any((rel) => rel.generalId == userId || rel.therapistId == userId);
  }

  bool isUserRequested(String userId) {
    if (requestList == null) return false;
    return requestList!.any((request) => request.recipientId == userId);
  }

  bool isUserReceived(String userId) {
    if (incomeList == null) return false;
    return incomeList!.any((request) => request.requesterId == userId);
  }
}