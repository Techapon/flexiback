import 'package:flexiback/features/device/domain/repositories/bluetooth_repository.dart';

class StopListeningUsecase {
  BluetoothRepository repo;

  StopListeningUsecase(this.repo);

  Future<void> call() {
    return repo.stopListening();
  }
}