import 'package:flexiback/core/enums/role.dart';
import 'package:flexiback/features/profile/domain/entities/profile_entity.dart';
import 'package:flexiback/features/relation/data/datasources/relation_datasources.dart';
import 'package:flexiback/features/relation/data/models/relation_reqeuest_model.dart';
import 'package:flexiback/features/relation/domain/entities/relation_reqeuest_entity.dart';
import 'package:flexiback/features/relation/domain/repositories/relation_repository.dart';

class RelationRepositoryImpl implements RelationRepository {
  final RelationDatasources datasource;

  RelationRepositoryImpl(this.datasource);

  Future<List<ProfileEntity>> getTargetUserList(Role targetRole) {
    return datasource.getTargetUserList(targetRole);
  }

  @override
  Future<void> relationRequest(String targetUserId, Role requesterRole) {
    return datasource.relationRequest(
      RelationReqeuestModel(
        recipientId: targetUserId,
        requesterRole: requesterRole,
      )
    );
  }

  @override
  Future<List<RelationReqeuestEntity>> getSenderRequest() {
    return datasource.getSenderRequest();
  }

  @override
  Future<void> deleteRequest(String requestId) {
    return datasource.deleteRequest(requestId);
  }
}