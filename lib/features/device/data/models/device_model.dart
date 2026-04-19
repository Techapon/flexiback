import 'package:flexiback/features/device/domain/entities/bt_connection_state.dart';
import 'package:flexiback/features/device/domain/entities/device_entity.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class DeviceModel extends DeviceEntity {
  DeviceModel({
    required super.name,
    required super.address,
    required super.state,
  });

  factory DeviceModel.fromEntity(DeviceEntity device) {
    return DeviceModel(
      name: device.name,
      address: device.address,
      state: device.state
    );
  }

  factory DeviceModel.fromBtDevice(BluetoothDevice device) {
    return DeviceModel(
      name: device.name,
      address: device.address,
      state: BtConnectionState.disconnected
    );
  }

  BluetoothDevice toBtDevice() {
    return BluetoothDevice(
      name: name,
      address: address,
    );
  }

  DeviceEntity toEntity() {
    return DeviceEntity(
      name: name,
      address: address,
      state: state
    );
  }


}