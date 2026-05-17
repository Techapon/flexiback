import 'package:flexiback/features/device/domain/entities/daily_progress_entity.dart';
import 'package:flexiback/features/device/domain/entities/full_data_entity.dart';
import 'package:flexiback/features/trend/data/datasources/trend_remote_datasource.dart';
import 'package:flexiback/features/trend/domain/entities/overview_entity.dart';
import 'package:flexiback/features/trend/domain/repositories/trend_repository.dart';
import 'package:flexiback/features/trend/domain/entities/therapy_session_trend_entity.dart';

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

  @override
  Future<List<DailyProgressEntity>> getDailyProgress(String userId) async {
    final models = await datasource.getDailyProgress(userId);
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<List<TherapySessionTrendEntity>> getTherapySessions(String userId) async {
    final models = await datasource.getTherapySessions(userId);
    return models.map((model) => model.toEntity()).toList();
  }
}
