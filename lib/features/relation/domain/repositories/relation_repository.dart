import 'dart:core';

import 'package:flexiback/core/enums/role.dart';
import 'package:flexiback/features/profile/domain/entities/profile_entity.dart';
import 'package:flexiback/features/relation/domain/entities/relation_reqeuest_entity.dart';

abstract class RelationRepository {
  Future<List<ProfileEntity>> getTargetUserList(Role targetRole);
  Future<List<RelationReqeuestEntity>> getSenderRequest();
  Future<List<RelationReqeuestEntity>> getIncomeRequest();
  Future<void> relationRequest(String targetUserId,Role requesterRole);

  Future<void> deleteRequest(String requestId);
}