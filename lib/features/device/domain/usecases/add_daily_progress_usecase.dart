import 'package:flexiback/core/entities/image_entity.dart';
import 'package:flexiback/features/device/domain/entities/daily_progress_entity.dart';
import 'package:flexiback/features/device/domain/repositories/device_db_repository.dart';

class AddDailyProgressUsecase {
  DeviceDBRepository repo;

  AddDailyProgressUsecase(this.repo);

  Future<void> call(DailyProgressEntity dailyProgress,ImageEntity image) async {
    return repo.addDailyProgress(dailyProgress,image);
  }
}