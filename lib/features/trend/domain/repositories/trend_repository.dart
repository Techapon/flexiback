import 'package:flexiback/features/trend/domain/entities/overview_entity.dart';

abstract class TrendRepository {
  Stream<List<OverviewEntity>> getOverviewData(String userId);
}
