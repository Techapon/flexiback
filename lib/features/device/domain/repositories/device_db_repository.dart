import 'package:flexiback/features/device/domain/entities/device_setting_entity.dart';
import 'package:flexiback/features/device/domain/entities/full_data_entity.dart';

abstract class DeviceDBRepository {
  Future<void> upDateDeviceSetting(DeviceSettingEntity setting);
  Future<DeviceSettingEntity> getDeviceSetting();
  Future<void> uploadDeviceUsage(FullDataEntity downsampedData);
}