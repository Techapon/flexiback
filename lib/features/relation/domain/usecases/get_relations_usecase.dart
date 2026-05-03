import 'package:flexiback/core/enums/role.dart';
import 'package:flexiback/features/relation/domain/entities/relation_entity.dart';
import 'package:flexiback/features/relation/domain/repositories/relation_repository.dart';

class GetRelationsUsecase {
  final RelationRepository repo;

  GetRelationsUsecase(this.repo);

  Stream<List<RelationEntity>> call(Role targetUser) {
    return repo.getRelations(targetUser);
  }
}
