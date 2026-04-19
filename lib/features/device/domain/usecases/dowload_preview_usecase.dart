import 'package:flexiback/features/device/domain/entities/bt_request.dart';
import 'package:flexiback/features/device/domain/repositories/bluetooth_repository.dart';

class DowloadPreviewUsecase {
  BluetoothRepository repo;

  DowloadPreviewUsecase(this.repo);

  Stream<String> call(BtRequest request) async* {
    final requestResult = await repo.sendRequest(request);

    if (requestResult) {
      yield* repo.dowloadPreview();
    }
  }
}