import 'package:flexiback/features/device/domain/entities/full_data_entity.dart';
import 'package:flexiback/features/trend/data/datasources/trend_remote_datasource.dart';
import 'package:flexiback/features/trend/domain/entities/overview_entity.dart';
import 'package:flexiback/features/trend/domain/repositories/trend_repository.dart';

class TrendRepositoryImpl implements TrendRepository {
  final TrendRemoteDatasource datasource;

  TrendRepositoryImpl(this.datasource);

  @override
  Stream<List<OverviewEntity>> getOverviewData(String userId) {
    return datasource.getOverviewData(userId).map(
      (list) => list.map((model) => model.toEntity()).toList()
    );
  }

  @override
  Future<FullDataEntity> getFullDataUsage(String userId, DateTime dateTime) {
    return datasource.getFullDataUsage(userId, dateTime);
  }
}
