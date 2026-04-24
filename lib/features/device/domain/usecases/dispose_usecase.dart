import 'package:flexiback/features/device/domain/repositories/bluetooth_repository.dart';

class DisposeUsecase {
  final BluetoothRepository repo;

  DisposeUsecase(this.repo);

  Future<void> call() {
    return repo.dispose();
  }
}