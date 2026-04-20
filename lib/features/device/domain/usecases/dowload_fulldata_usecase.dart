import 'package:flexiback/features/device/domain/entities/classes/full_data_entity.dart';
import 'package:flexiback/features/device/domain/entities/enums/bt_request.dart';
import 'package:flexiback/features/device/domain/repositories/bluetooth_repository.dart';

class DowloadFulldataUsecase {
  BluetoothRepository repo;

  DowloadFulldataUsecase(this.repo);

  Stream<FullDataEntity> call() async* {
    FullDataEntity fulldata;
    try {
      final requestResult = await repo.sendRequest(BtRequest.DowloadData);

      if (requestResult) {
        await for (final data in repo.dowloadFullData()) {
          fulldata = data;

          print("Full Data : $fulldata");

          yield data;
        }
      }
    } catch (e) {
      rethrow;
    }
  }
}