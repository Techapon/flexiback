import 'package:flexiback/core/enums/role.dart';
import 'package:flexiback/features/profile/domain/entities/profile_entity.dart';

abstract class RelationRepository {
  Future<List<ProfileEntity>> getTargetUserList(Role targetRole);
}