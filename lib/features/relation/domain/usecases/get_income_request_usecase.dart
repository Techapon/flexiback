import 'package:flexiback/features/relation/domain/entities/relation_reqeuest_entity.dart';
import 'package:flexiback/features/relation/domain/repositories/relation_repository.dart';

class GetIncomeRequestUsecase {
  RelationRepository repo;

  GetIncomeRequestUsecase(this.repo);

  Future<List<RelationReqeuestEntity>> call() {
    return repo.getIncomeRequest();
  }
}