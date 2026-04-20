import 'package:flexiback/features/device/domain/repositories/bluetooth_repository.dart';

class DisconnectUsecase {
  final BluetoothRepository repo;

  DisconnectUsecase(this.repo);

  Future<void> call() {
    return repo.disconnect();
  }
}