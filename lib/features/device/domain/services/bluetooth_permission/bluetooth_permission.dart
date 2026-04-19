import 'package:device_info_plus/device_info_plus.dart';
import 'dart:io';

import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class BluetoothPermission {

  static Future<bool> requestPermissions() async {
    if (!Platform.isAndroid) return false;

    final sdkVersion = await _getAndroidSdkVersion();

    List<Permission> permissions = [
      Permission.location,
    ];

    if (sdkVersion >= 31) {
      permissions.addAll([
        Permission.bluetoothConnect,
        Permission.bluetoothScan,
      ]);
    } else {
      permissions.add(Permission.bluetooth);
    }

    final statuses = await permissions.request();

    return statuses.values.every(
      (status) => status == PermissionStatus.granted
    );
  }

  static Future<bool> checkPermissions() async {
    final sdkVersion = await _getAndroidSdkVersion();

    if (sdkVersion >= 31) {
      final connect = await Permission.bluetoothConnect.isGranted;
      final scan = await Permission.bluetoothScan.isGranted;
      final location = await Permission.location.isGranted;
      return connect && scan && location;
    } else {
      final bt = await Permission.bluetooth.isGranted;
      final location = await Permission.location.isGranted;
      return bt && location;
    }
  }

  static Future<void> openSettings() async {
    await openAppSettings();
  }

  static Future<int> _getAndroidSdkVersion() async {
    try {
      final info = await DeviceInfoPlugin().androidInfo;
      return info.version.sdkInt;
    } catch (_) {
      return 30;
    }
  }

  // open bluetooth
  static Future<bool> isBluetoothEnabled() async {
    return await FlutterBluetoothSerial.instance.isEnabled ?? false;
  }

  static Future<bool> enableBluetooth() async {
    final result = await FlutterBluetoothSerial.instance.requestEnable();
    return result ?? false;
  }

}