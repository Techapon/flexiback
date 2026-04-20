import 'package:flexiback/core/exception/bluetooth_exception/bluetooth_failure.dart';
import 'package:flexiback/features/device/data/datasources/bluetooth_datasource.dart';
import 'package:flexiback/features/device/data/models/device_model.dart';
import 'package:flexiback/features/device/data/models/device_setting_model.dart';
import 'package:flexiback/features/device/domain/entities/classes/device_setting_entity.dart';
import 'package:flexiback/features/device/domain/entities/classes/full_data_entity.dart';
import 'package:flexiback/features/device/domain/entities/enums/bt_request.dart';
import 'package:flexiback/features/device/domain/entities/classes/device_entity.dart';
import 'package:flexiback/features/device/domain/repositories/bluetooth_repository.dart';

import '../../domain/entities/classes/preview_entity.dart';

class BluetoothRepositoryImpl implements BluetoothRepository {
  final BluetoothDatasource datasource;

  BluetoothRepositoryImpl(this.datasource);

  // -------------
  // Find Devices
  // -------------
  @override
  Stream<List<DeviceEntity>> findDeivce() {
    datasource.findDevice();

    return datasource.deviceStream
      .map(
        (models) => models.map((m) => m.toEntity()).toList()
      )
      .handleError((e) {
        throw BluetoothFailre.bluetoothOff();
      });
  }

  // -------------
  // Connection
  // -------------
  @override
  Future<bool> connectDevice(DeviceEntity device) {
    return datasource.connect(
      DeviceModel.fromEntity(device).toBtDevice()
    );
  }

  // -------------
  // Send Data
  // -------------
  @override
  Future<bool> sendRequest(BtRequest request) {
    return datasource.sendRequest(request);
  }

  @override
  Future<bool> uploadDeviceSetting(DeviceSettingEntity setting) {
    return datasource.sendString(
      DeviceSettingModel.fromEntity(setting).toJsonString()
    );
  }

  // -------------
  // Dowlaod
  // -------------
  @override
  Stream<PreviewEntity> dowloadPreview() {
    datasource.startListening();
    return datasource.dataStream.map(
      (data) => PreviewEntity(jsonString: data)
    );
  }

  @override
  Stream<FullDataEntity> dowloadFullData() {
    datasource.startListening();
    return datasource.dataStream.map(
      (data) => FullDataEntity(jsonString: data)
    );
  }

  // -------------
  // Dispsoe
  // -------------
  @override
  Future<void> disconnect() {
    return datasource.dispose();
  }

}