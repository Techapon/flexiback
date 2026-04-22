import 'package:flexiback/features/device/domain/enums/bt_request.dart';
import 'package:flexiback/features/device/domain/entities/device_entity.dart';

import '../entities/device_setting_entity.dart';
import '../entities/full_data_entity.dart';
import '../entities/preview_entity.dart';

abstract class BluetoothRepository {
  Stream<List<DeviceEntity>> findDeivce();

  // connection
  Future<bool> connectDevice(DeviceEntity device);
  Future<void> disconnect();
  
  // send
  Future<bool> sendRequest(BtRequest request);
  Future<bool> uploadDeviceSetting(DeviceSettingEntity setting);
  
  // dowload 
  Stream<PreviewEntity> dowloadPreview();
  Stream<FullDataEntity> dowloadFullData();

  
  
}