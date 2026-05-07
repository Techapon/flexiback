import 'package:flexiback/features/trend/domain/entities/overview_entity.dart';
import 'package:flexiback/features/trend/domain/repositories/trend_repository.dart';

class GetOverviewUsecase {
  TrendRepository repo;

  GetOverviewUsecase(this.repo);

  Stream<List<OverviewEntity>> call(String userId) {
    return repo.getOverviewData(userId);
  }
}
