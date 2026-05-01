import 'package:flexiback/features/device/domain/enums/bt_request.dart';
import 'package:flexiback/features/device/domain/repositories/bluetooth_repository.dart';

class ResetUsecase {
  BluetoothRepository repo;

  ResetUsecase(this.repo);

  Future<void> call() {
    return repo.sendMethod(BtRequest.Reset);
  }
}