import 'package:flexiback/features/device/domain/entities/device_setting_entity.dart';
import 'package:flexiback/features/device/domain/repositories/device_db_repository.dart';

class GetDeviceSettingUsecase {
  DeviceDBRepository repo;

  GetDeviceSettingUsecase(this.repo);

  Future<DeviceSettingEntity> call() {
    return repo.getDeviceSetting();
  }
}