import 'package:flexiback/features/device/domain/enums/bt_request.dart';
import 'package:flexiback/features/device/domain/repositories/bluetooth_repository.dart';

class CalibrateUsecase {
  BluetoothRepository repo;

  CalibrateUsecase(this.repo);

  Future<void> call() {
    return repo.sendMethod(BtRequest.Calibrate);
  }
}