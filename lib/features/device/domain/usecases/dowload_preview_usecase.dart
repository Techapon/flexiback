import 'package:flexiback/features/device/domain/enums/bt_request.dart';
import 'package:flexiback/features/device/domain/repositories/bluetooth_repository.dart';
import 'package:flexiback/features/device/domain/entities/preview_entity.dart';

class DowloadPreviewUsecase {
  final BluetoothRepository repo;

  DowloadPreviewUsecase(this.repo);

  Stream<PreviewEntity> call() async* {
    try {
      final requestResult = await repo.sendRequest(BtRequest.DowloadPreview);

      if (requestResult) {
        yield* repo.dowloadPreview();
      }
    } catch (e) {
      rethrow;
    }
  }
}