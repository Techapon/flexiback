import 'package:flexiback/features/device/domain/entities/device_entity.dart';
import 'package:flexiback/features/device/domain/repositories/bluetooth_repository.dart';

class GetDeviceUsecase {
  BluetoothRepository repo;

  GetDeviceUsecase(this.repo);

  DeviceEntity call() {
    return repo.getDeviceData();
  }
}