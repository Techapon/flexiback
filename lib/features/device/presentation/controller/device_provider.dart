import 'dart:async';

import 'package:flexiback/core/exception/bluetooth_exception/bluetooth_failure.dart';
import 'package:flexiback/features/device/data/datasources/bluetooth_datasource.dart';
import 'package:flexiback/features/device/data/repositories/bluetooth_repository_impl.dart';
import 'package:flexiback/features/device/domain/entities/device_entity.dart';
import 'package:flexiback/features/device/domain/usecases/connect_device_usecase.dart';
import 'package:flexiback/features/device/domain/usecases/find_devices_usecase.dart';
import 'package:flexiback/features/device/domain/usecases/open_settings_usecase.dart';
import 'package:flutter/material.dart';

class DeviceProvider extends ChangeNotifier {
  final findDevicesUsecase = FindDevicesUsecase(BluetoothRepositoryImpl(BluetoothDatasource()));
  final openSettingsUsecase = OpenSettingsUsecase();
  final connectDeviceUsecase = ConnectDeviceUsecase(BluetoothRepositoryImpl(BluetoothDatasource()));

  bool isLoading = false;
  bool isConnecting = false;
  bool isStream = false;
  String? error;
  BluetoothFailre? failre;

  List<DeviceEntity> devices = [];

  StreamSubscription? _sub;

  Future<void> findDevices() async {
    error = null;
    failre = null;
    isStream = true;
    
    devices = [];
    notifyListeners();
    try {
      _sub = findDevicesUsecase.call().listen(
        (data) {
        devices = data;
        notifyListeners();
      },
      onDone: () async {
        await _sub?.cancel();
        isStream = false;
        notifyListeners();
      },
      onError: (e) {
        _sub = null;
      }
      );

    } on BluetoothFailre catch (e) {
      failre = e;
      error = e.toString();
    } catch (e) {
      error = e.toString();
    }
  }

  Future<void> connect(
    DeviceEntity device
  ) async {
    error = null;
    isConnecting = true;
    notifyListeners();
    try {
      final result = await connectDeviceUsecase.call(device);

    } catch (e) {
      error = e.toString();
      print("ERROR --- $error");
    }
    isConnecting = false;
    notifyListeners();
  }

  Future<void> openSetting() async {
    await openSettingsUsecase.call();
  }
}