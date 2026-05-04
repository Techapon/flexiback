import 'package:flexiback/core/enums/role.dart';
import 'package:flexiback/core/mappers/get_role.dart';
import 'package:flexiback/features/profile/data/datasources/profile_remote_datasource.dart';
import 'package:flexiback/features/profile/domain/entities/profile_entity.dart';
import 'package:flexiback/features/relation/data/datasources/relation_datasources.dart';
import 'package:flexiback/features/relation/data/models/relation_reqeuest_model.dart';
import 'package:flexiback/features/relation/domain/entities/relation_reqeuest_entity.dart';
import 'package:flexiback/features/relation/domain/entities/relation_entity.dart';
import 'package:flexiback/features/relation/data/models/relation_model.dart';
import 'package:flexiback/features/relation/domain/repositories/relation_repository.dart';

class RelationRepositoryImpl implements RelationRepository {
  final RelationDatasources datasource;
  final ProfileRemoteDatasource profileDatasource;

  RelationRepositoryImpl(this.datasource,this.profileDatasource);

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
  Future<List<RelationReqeuestEntity>> getIncomeRequest() {
    return datasource.getIncomeRequest();
  }

  @override
  Future<void> deleteRequest(String requestId) {
    return datasource.deleteRequest(requestId);
  }

  @override
  Future<void> acceptRequest(RelationReqeuestEntity request) async {
    await datasource.deleteRequest(request.id);
    
    final String generalId;
    final String therapistId;

    if (getRole(request.requesterRole) == Role.General) {
      generalId = request.requesterId;
      therapistId = request.recipientId;
    } else {
      generalId = request.recipientId;
      therapistId = request.requesterId;
    }

    final model = RelationModel(
      id: '',
      generalId: generalId,
      therapistId: therapistId,
      createdAt: DateTime.now(),
    );

    return datasource.acceptRequest(model);
  }

  @override
  Stream<List<RelationEntity>> getRelations(Role targetUser) {
    return datasource.getRelations().asyncMap(
      (relations) async {
        final fullRelation = await Future.wait(
          relations.map((r) async {
            final String targetUserId;

            switch (targetUser) {
              case Role.General :
                targetUserId = r.generalId;
              case Role.Therapist:
                targetUserId = r.therapistId;
            }

            print("Target ID : ${targetUserId}");
            
            r.userProfile = await profileDatasource.getProfile(userTargetId: targetUserId);
            return r.toEntity();
          })
        );
        return fullRelation;
      }
    );
  }

  @override
  Future<void> deleteRelation(String relationId) {
    return datasource.deleteRelation(relationId);
  }
}