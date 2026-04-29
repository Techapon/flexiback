import 'package:flexiback/core/enums/role.dart';
import 'package:flexiback/core/mappers/get_role.dart';
import 'package:flexiback/features/relation/domain/entities/relation_reqeuest_entity.dart';

class RelationReqeuestModel {
  final String? id;
  String? requesterId;
  final String recipientId;
  final Role requesterRole;
  final DateTime? createAt;

  RelationReqeuestModel({
    this.id,
    this.requesterId,
    required this.recipientId,
    required this.requesterRole,
    this.createAt,
  });

  factory RelationReqeuestModel.fromMap(Map<String,dynamic> map) {
    return RelationReqeuestModel(
      id: map["id"],
      requesterId: map["requester_id"],
      recipientId: map["recipient_id"],
      requesterRole: getRole(map["requester_role"]),
      createAt:  DateTime.parse(map["create_at"]).toLocal() 
    );
  }

  // factory RelationReqeuestModel.fromEntity(RelationReqeuestEntity entity) {
  //   return RelationReqeuestModel(
  //     id: entity.id,
  //     requesterId: entity.requesterId,
  //     recipientId: entity.recipientId,
  //     requesterRole: getRole(entity.requesterRole),
  //     createAt: entity.createAt
  //   );
  // }

  Map<String,dynamic> toMap() {
    return {
      'requester_id': requesterId,
      'recipient_id': recipientId,
      'requester_role': requesterRole.entity,
    };
  }

  RelationReqeuestEntity toEntity() {
    return RelationReqeuestEntity(
      id: id!,
      requesterId: requesterId!,
      recipientId: recipientId,
      requesterRole: requesterRole.entity,
      createAt: createAt!,
    );
  }
}