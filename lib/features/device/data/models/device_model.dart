import 'package:flexiback/features/device/domain/entities/device_entity.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class DeviceModel extends DeviceEntity {
  DeviceModel({
    required super.name,
    required super.address,
  });

  factory DeviceModel.fromEntity(DeviceEntity device) {
    return DeviceModel(
      name: device.name,
      address: device.address,
    );
  }

  factory DeviceModel.fromBtDevice(BluetoothDevice device) {
    return DeviceModel(
      name: device.name,
      address: device.address,
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
    );
  }


}