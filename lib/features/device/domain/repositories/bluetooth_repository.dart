import 'package:flexiback/features/device/domain/entities/bt_request.dart';
import 'package:flexiback/features/device/domain/entities/device_entity.dart';

abstract class BluetoothRepository {
  Stream<List<DeviceEntity>> findDeivce();
  Future<bool> connectDevice(DeviceEntity device);
  
  // data
  Future<bool> sendRequest(BtRequest request);
  Stream<String> dowloadPreview();
}