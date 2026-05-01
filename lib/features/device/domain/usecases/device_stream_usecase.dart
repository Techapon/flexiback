import 'package:flexiback/features/device/domain/enums/bt_request.dart';
import 'package:flexiback/features/device/domain/repositories/bluetooth_repository.dart';
import 'package:flexiback/features/device/domain/entities/preview_entity.dart';

class DeviceStreamUsecase {
  final BluetoothRepository repo;

  DeviceStreamUsecase(this.repo);

  Stream<Map<String,dynamic>> call() async* {
    try {
      // final requestResult = await repo.sendRequest(BtRequest.DowloadPreview);

      // print("REQUEST -- ${requestResult}");
      // if (requestResult) {
        yield* repo.realtimeData();
      // }
    } catch (e) {
      rethrow;
    }
  }
}