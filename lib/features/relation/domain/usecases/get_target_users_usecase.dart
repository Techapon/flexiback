import 'package:flexiback/core/enums/role.dart';
import 'package:flexiback/features/profile/domain/entities/profile_entity.dart';
import 'package:flexiback/features/relation/domain/repositories/relation_repository.dart';

class GetTargetUsersUsecase {
  RelationRepository repo;

  GetTargetUsersUsecase(this.repo);

  Future<List<ProfileEntity>> call(Role targetRole) {
    return repo.getTargetUserList(targetRole);
  } 
}