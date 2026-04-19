import 'package:flexiback/features/device/domain/entities/device_entity.dart';
import 'package:flexiback/features/device/domain/repositories/bluetooth_repository.dart';

class ConnectDeviceUsecase {
  BluetoothRepository repo;

  ConnectDeviceUsecase(this.repo);

  Future<bool> call(DeviceEntity device) async {
    return repo.connectDevice(device);
  }
}