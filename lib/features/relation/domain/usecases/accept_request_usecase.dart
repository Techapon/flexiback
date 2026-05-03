import 'package:flexiback/features/relation/domain/entities/relation_reqeuest_entity.dart';
import 'package:flexiback/features/relation/domain/repositories/relation_repository.dart';

class AcceptRequestUsecase {
  RelationRepository repo;

  AcceptRequestUsecase(this.repo);

  Future<void> call(RelationReqeuestEntity request) {
    return repo.acceptRequest(request);
  }
}