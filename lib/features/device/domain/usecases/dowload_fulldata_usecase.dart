import 'dart:async';

import 'package:flexiback/features/device/domain/entities/full_data_entity.dart';
import 'package:flexiback/features/device/domain/entities/preview_entity.dart';
import 'package:flexiback/features/device/domain/enums/bt_request.dart';
import 'package:flexiback/features/device/domain/repositories/bluetooth_repository.dart';
import 'package:flexiback/features/device/domain/services/on_off/on_off_donwsampling.dart';

import '../repositories/device_db_repository.dart';

class DowloadFulldataUsecase {
  BluetoothRepository btRepo;
  DeviceDBRepository dbRepo;

  DowloadFulldataUsecase(this.btRepo,this.dbRepo);

  Stream<FullDataEntity> call(PreviewEntity preview) async* {
    FullDataEntity? fulldata;
    try {
      final requestResult = await btRepo.sendRequest(BtRequest.DowloadData);


      if (requestResult) {
        await for (final data in btRepo.dowloadFullData(preview)) {
          fulldata = data;

          yield data;
        }


        if (fulldata != null) {
          print("NOT NULL");
          final FullDataEntity? downSampedData =  OnOffDonwsampling.dowSampling(fulldata);

          print(downSampedData?.dotList.length ?? "No data -/-/-/- ");

          if (downSampedData != null) {
            await dbRepo.uploadDeviceUsage(downSampedData);
          }

        }else {

        }
      }
    } catch (e) {
      rethrow;
    }
  }
}