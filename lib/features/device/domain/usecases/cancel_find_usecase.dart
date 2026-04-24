import 'package:flexiback/features/device/domain/repositories/bluetooth_repository.dart';

class CancelFindUsecase {
  BluetoothRepository repo;

  CancelFindUsecase(this.repo);

  Future<void> call() {
    return repo.cancelFind();
  }
}