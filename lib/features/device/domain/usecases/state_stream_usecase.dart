import 'package:flexiback/features/device/data/datasources/bluetooth_datasource.dart';
import 'package:flexiback/features/device/domain/enums/bt_connection_state.dart';
import 'package:flexiback/features/device/domain/repositories/bluetooth_repository.dart';

class StateStreamUsecase {
  BluetoothRepository repo;

  StateStreamUsecase(this.repo);

  Stream<BtConnectionState> call() async* {
    yield* repo.stateStraem();
  }
}