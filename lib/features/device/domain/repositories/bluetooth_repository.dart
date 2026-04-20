import 'package:flexiback/features/device/domain/entities/enums/bt_request.dart';
import 'package:flexiback/features/device/domain/entities/classes/device_entity.dart';

import '../entities/classes/device_setting_entity.dart';
import '../entities/classes/full_data_entity.dart';
import '../entities/classes/preview_entity.dart';

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