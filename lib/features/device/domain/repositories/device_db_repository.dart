import 'package:flexiback/features/device/domain/entities/classes/device_setting_entity.dart';

abstract class DeviceDBRepository {
  Future<void> upDateDeviceSetting(DeviceSettingEntity setting);
  Future<DeviceSettingEntity> getDeviceSetting();
}