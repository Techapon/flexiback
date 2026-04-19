import 'package:flexiback/core/exception/bluetooth_exception/bluetooth_error_type.dart';

class BluetoothFailre implements Exception {
  final BluetoothErrorType type;
  final String message;

  const BluetoothFailre({
    required this.type,
    required this.message,
    this.debugMessage,
  });

  final String? debugMessage;

  factory BluetoothFailre.noPermission([String? debugMessage]) => BluetoothFailre(
        type: BluetoothErrorType.noPermission,
        message: 'Please allow the permissions for connect to the devices',
        debugMessage: debugMessage,
      );

  factory BluetoothFailre.bluetoothOff([String? debugMessage]) => BluetoothFailre(
        type: BluetoothErrorType.bluetoothoff,
        message: 'Your need to opeon your Bluetooth to connect the devices',
        debugMessage: debugMessage,
      );

  @override
  String toString() => message;
}