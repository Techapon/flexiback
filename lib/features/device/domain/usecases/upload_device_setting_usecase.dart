import 'package:flexiback/features/device/domain/repositories/bluetooth_repository.dart';
import 'package:flexiback/features/device/domain/repositories/device_db_repository.dart';

import '../entities/classes/device_setting_entity.dart';

class UploadDeviceSettingUsecase {
  BluetoothRepository btRepo;
  DeviceDBRepository dbRepo;

  UploadDeviceSettingUsecase(this.btRepo, this.dbRepo);

  Future<DeviceSettingEntity> call(DeviceSettingEntity setting) async {
    try {
      final uploadResult = await btRepo.uploadDeviceSetting(setting);

        await dbRepo.upDateDeviceSetting(setting);
        return dbRepo.getDeviceSetting();
    } catch (e) {
      rethrow;
    }
  }
}