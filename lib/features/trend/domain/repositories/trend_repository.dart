import 'package:flexiback/features/device/domain/entities/full_data_entity.dart';
import 'package:flexiback/features/trend/domain/entities/overview_entity.dart';

abstract class TrendRepository {
  Stream<List<OverviewEntity>> getOverviewData(String userId);
  Future<FullDataEntity> getFullDataUsage(String userId, DateTime dateTime);
}
