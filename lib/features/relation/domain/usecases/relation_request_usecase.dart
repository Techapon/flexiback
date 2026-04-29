import 'package:flexiback/core/enums/role.dart';
import 'package:flexiback/features/relation/domain/repositories/relation_repository.dart';

class RelationRequestUsecase {
  RelationRepository repo;

  RelationRequestUsecase(this.repo);

  Future<void> call(String targetUserId, Role requesterRole) {
    return repo.relationRequest(targetUserId, requesterRole);
  }
}
