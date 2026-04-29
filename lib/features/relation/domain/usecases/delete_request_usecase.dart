import 'package:flexiback/features/relation/domain/repositories/relation_repository.dart';

class DeleteRequestUsecase {
  RelationRepository repo;

  DeleteRequestUsecase(this.repo);

  Future<void> call(String requestId) {
    return repo.deleteRequest(requestId);
  }
}