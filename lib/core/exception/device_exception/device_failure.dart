import 'package:flexiback/core/exception/device_exception/device_error_type.dart';

class DeviceFailure implements Exception {
  final DeviceErrorType type;
  final String message;

  const DeviceFailure({
    required this.type,
    required this.message,
  });

  factory DeviceFailure.connectionError([String? debugMessage]) => DeviceFailure(
        type: DeviceErrorType.connectionError,
        message: 'Connection error, Please try again.',
      );
  
  factory DeviceFailure.sendError([String? debugMessage]) => DeviceFailure(
        type: DeviceErrorType.sendError,
        message: 'Unable to contact the device, Please try again.',
      );

  factory DeviceFailure.dowloadError([String? debugMessage]) => DeviceFailure(
        type: DeviceErrorType.dowloadError,
        message: 'Unable to dowload the data, Please try again.',
      );
  
  factory DeviceFailure.timOut([String? debugMessage]) => DeviceFailure(
        type: DeviceErrorType.timout,
        message: "It's take too long time, Please try again.",
      );

  @override
  String toString() => message;
}