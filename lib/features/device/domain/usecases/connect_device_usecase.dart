import 'package:flexiback/features/device/domain/entities/classes/device_entity.dart';
import 'package:flexiback/features/device/domain/repositories/bluetooth_repository.dart';

class ConnectDeviceUsecase {
  final BluetoothRepository repo;

  ConnectDeviceUsecase(this.repo);

  Future<bool> call(DeviceEntity device) {
    return repo.connectDevice(device);
  }
}