import 'package:flexiback/features/device/domain/entities/daily_progress_entity.dart';
import 'package:flexiback/features/device/domain/repositories/device_db_repository.dart';

class GetDailyProgressUsecase {
  DeviceDBRepository repo;

  GetDailyProgressUsecase(this.repo);

  Stream<List<DailyProgressEntity>> call(String userId) {
    return repo.getDailyProgress(userId);
  }
}