import 'package:flexiback/features/device/data/datasources/device_remote_datasource.dart';
import 'package:flexiback/features/device/data/models/device_setting_model.dart';
import 'package:flexiback/features/device/data/models/fulldata_model.dart';

import '../../domain/entities/device_setting_entity.dart';
import '../../domain/entities/full_data_entity.dart';
import '../../domain/repositories/device_db_repository.dart';

class DeviceDbRepositoryImpl implements DeviceDBRepository {
  final DeviceRemoteDatasource datasource;

  DeviceDbRepositoryImpl(this.datasource);

  @override
  Future<void> upDateDeviceSetting(DeviceSettingEntity setting) {
    return datasource.updateDevicSetting(DeviceSettingModel.fromEntity(setting));
  }

  @override
  Future<DeviceSettingEntity> getDeviceSetting() async {
    final model = await datasource.getDevicSetting();
    return model.toEntity();
  }

  @override
  Future<void> uploadDeviceUsage(FullDataEntity downsampedData) async {
    return datasource.uploadDeviceUsage(FulldataModel.fromEntity(downsampedData));
  }
}