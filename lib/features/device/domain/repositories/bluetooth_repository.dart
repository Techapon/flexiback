import 'package:flexiback/features/device/domain/entities/device_entity.dart';

abstract class BluetoothRepository {
  Stream<List<DeviceEntity>> findDeivce();
  Future<bool> connectDevice(DeviceEntity device);
}