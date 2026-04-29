import 'dart:convert';

import 'package:flexiback/core/exception/bluetooth_exception/bluetooth_failure.dart';
import 'package:flexiback/features/device/data/datasources/bluetooth_datasource.dart';
import 'package:flexiback/features/device/data/models/device_model.dart';
import 'package:flexiback/features/device/data/models/device_setting_model.dart';
import 'package:flexiback/features/device/domain/entities/device_setting_entity.dart';
import 'package:flexiback/features/device/domain/entities/full_data_entity.dart';
import 'package:flexiback/features/device/domain/enums/bt_connection_state.dart';
import 'package:flexiback/features/device/domain/enums/bt_request.dart';
import 'package:flexiback/features/device/domain/entities/device_entity.dart';
import 'package:flexiback/features/device/domain/repositories/bluetooth_repository.dart';

import '../../domain/entities/preview_entity.dart';
import '../models/fulldata_model.dart';

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
  // State
  // -------------
  @override
  Stream<BtConnectionState> stateStraem(){
    return datasource.stateStream;
  }

  // -------------
  // Connection
  // -------------
  @override
  Future<void> connectDevice(DeviceEntity device) {
    return datasource.connect(
      DeviceModel.fromEntity(device).toBtDevice()
    );
  }

  @override
  DeviceEntity getDeviceData() {
    final device = datasource.conntedDevice;
    if (device == null) {
      throw BluetoothFailre.noConnection();
    }
    DeviceModel models = DeviceModel.fromBtDevice(device);
    return models.toEntity();
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
      (data) => FulldataModel.fromMap(jsonDecode(data)).toEntity()
    );
  }

  // -------------
  // Dispsoe
  // -------------
  @override
  Future<void> dispose() {
    return datasource.dispose();
  }

  @override
  Future<void> cancelFind() {
    return datasource.cancelFind();
  }

  @override
  Future<void> disconect() {
    return datasource.disconnect();
  }

}