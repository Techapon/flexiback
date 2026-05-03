import 'package:flexiback/features/relation/domain/repositories/relation_repository.dart';

class DeleteRelationUsecase {
  final RelationRepository repo;

  DeleteRelationUsecase(this.repo);

  Future<void> call(String relationId) {
    return repo.deleteRelation(relationId);
  }
}
