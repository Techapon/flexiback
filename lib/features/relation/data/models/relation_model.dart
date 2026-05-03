import 'package:flexiback/features/relation/domain/entities/relation_entity.dart';

class RelationModel extends RelationEntity {
  RelationModel({
    required super.id,
    required super.generalId,
    required super.therapistId,
    required super.createdAt,
    super.userProfile
  });

  factory RelationModel.fromMap(Map<String, dynamic> json) {
    return RelationModel(
      id: json['id'],
      generalId: json['general_id'],
      therapistId: json['therapist_id'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  factory RelationModel.fromEntity(RelationEntity entity) {
    return RelationModel(
      id: entity.id,
      generalId: entity.generalId,
      therapistId: entity.therapistId,
      createdAt: entity.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'general_id': generalId,
      'therapist_id': therapistId,
    };
  }

  RelationEntity toEntity() {
    return RelationEntity(
      id: id,
      generalId: generalId,
      therapistId: therapistId,
      createdAt: createdAt,
      userProfile: userProfile
    );
  }  
}