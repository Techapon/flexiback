import 'package:flexiback/core/enums/role.dart';
import 'package:flexiback/features/relation/domain/entities/relation_reqeuest_entity.dart';
import 'package:flexiback/features/relation/domain/repositories/relation_repository.dart';

class GetRequestUsecase {
  RelationRepository repo;

  GetRequestUsecase(this.repo);

  Future<List<RelationReqeuestEntity>> call() {
    return repo.getSenderRequest();
  }
}
