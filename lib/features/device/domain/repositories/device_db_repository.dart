import 'package:flexiback/core/entities/image_entity.dart';
import 'package:flexiback/features/device/domain/entities/daily_progress_entity.dart';
import 'package:flexiback/features/device/domain/entities/device_setting_entity.dart';
import 'package:flexiback/features/device/domain/entities/full_data_entity.dart';

abstract class DeviceDBRepository {
  Future<void> upDateDeviceSetting(DeviceSettingEntity setting);
  Future<DeviceSettingEntity> getDeviceSetting();
  Future<void> uploadDeviceUsage(FullDataEntity downsampedData);

  // dialy progress
  Future<void> addDailyProgress(DailyProgressEntity dailyProgress,ImageEntity image);
  // Future<void> deleteDailyProgress(String id);
  Stream<List<DailyProgressEntity>> getDailyProgress(String userId);
}