import 'package:flexiback/features/device/domain/entities/full_data_entity.dart';
import 'package:flexiback/features/trend/domain/repositories/trend_repository.dart';

class GetFullDataUsageUsecase {
  TrendRepository repo;

  GetFullDataUsageUsecase(this.repo);

  Future<FullDataEntity> call(String userId, DateTime dateTime) {
    return repo.getFullDataUsage(userId, dateTime);
  }
}
