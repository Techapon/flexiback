import 'package:flexiback/core/exception/bluetooth_exception/bluetooth_failure.dart';
import 'package:flexiback/features/device/domain/entities/device_entity.dart';
import 'package:flexiback/features/device/domain/repositories/bluetooth_repository.dart';
import 'package:flexiback/features/device/domain/services/bluetooth_permission/bluetooth_permission.dart';

import '../../../../core/constants/flexiback.dart';

class FindDevicesUsecase {
  final BluetoothRepository repo;
  
  FindDevicesUsecase(this.repo);

  Stream<List<DeviceEntity>> call() async* {
    // yield* repo.findDeivce().map(
    //   (devices) => devices.where((device) => device.name == Flexiback.name).toList()
    // );
    yield* repo.findDeivce();
  }
}