import 'package:flexiback/features/device/domain/repositories/device_db_repository.dart';

class DeleteDailyProgressUsecase {
  final DeviceDBRepository repository;

  DeleteDailyProgressUsecase(this.repository);

  Future<void> call(String id) {
    return repository.deleteDailyProgress(id);
  }
}
