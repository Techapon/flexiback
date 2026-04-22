import 'dart:async';

import 'package:flexiback/features/device/domain/entities/full_data_entity.dart';
import 'package:flexiback/features/device/domain/enums/bt_request.dart';
import 'package:flexiback/features/device/domain/repositories/bluetooth_repository.dart';

import '../repositories/device_db_repository.dart';
import '../services/lttb/lttb_service.dart';

class DowloadFulldataUsecase {
  BluetoothRepository btRepo;
  DeviceDBRepository dbRepo;

  DowloadFulldataUsecase(this.btRepo,this.dbRepo);

  Stream<FullDataEntity> call() async* {
    FullDataEntity? fulldata;
    try {
      final requestResult = await btRepo.sendRequest(BtRequest.DowloadData);

      if (requestResult) {
        await for (final data in btRepo.dowloadFullData()) {
          fulldata = data;

          print("coming Data : $fulldata");

          yield data;
        }

        if (fulldata != null) {
          final FullDataEntity? downSampedData =  LTTB.LTTBdownsamp(fulldata);

          if (downSampedData != null) {
            await dbRepo.uploadDeviceUsage(downSampedData);
          }

        }
      }
    } catch (e) {
      rethrow;
    }
  }
}