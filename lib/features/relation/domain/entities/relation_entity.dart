import 'package:flexiback/features/profile/domain/entities/profile_entity.dart';

class RelationEntity {
  final String id;
  final String generalId;
  final String therapistId;
  final DateTime createdAt;
  ProfileEntity? userProfile;

  RelationEntity({
    required this.id,
    required this.generalId,
    required this.therapistId,
    required this.createdAt,
    required this.userProfile
  });
}