import 'package:flexiback/features/device/domain/entities/daily_progress_entity.dart';
import 'package:flexiback/features/trend/domain/repositories/trend_repository.dart';
import 'package:flexiback/features/trend/domain/service/charts/fill_the_gap_day.dart';
import 'package:flexiback/features/trend/domain/service/charts/fill_the_gap_month.dart';

class GetDailyProgressTrendUsecase {
  final TrendRepository repo;

  GetDailyProgressTrendUsecase(this.repo);

  Future<List<DailyProgressEntity>> call(String userId) async {
    return repo.getDailyProgress(userId);
  }
}
