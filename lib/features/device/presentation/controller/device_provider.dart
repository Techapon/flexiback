import 'dart:async';

import 'package:flexiback/core/exception/bluetooth_exception/bluetooth_failure.dart';
import 'package:flexiback/features/device/data/datasources/bluetooth_datasource.dart';
import 'package:flexiback/features/device/data/repositories/bluetooth_repository_impl.dart';
import 'package:flexiback/features/device/domain/entities/classes/device_entity.dart';
import 'package:flexiback/features/device/domain/entities/classes/device_setting_entity.dart';
import 'package:flexiback/features/device/domain/entities/classes/preview_entity.dart';
import 'package:flexiback/features/device/domain/repositories/device_db_repository.dart';
import 'package:flexiback/features/device/domain/usecases/connect_device_usecase.dart';
import 'package:flexiback/features/device/domain/usecases/disconnect_usecase.dart';
import 'package:flexiback/features/device/domain/usecases/dowload_preview_usecase.dart';
import 'package:flexiback/features/device/domain/usecases/find_devices_usecase.dart';
import 'package:flexiback/features/device/domain/usecases/open_settings_usecase.dart';
import 'package:flexiback/features/device/domain/usecases/upload_device_setting_usecase.dart';
import 'package:flutter/material.dart';

import '../../data/datasources/device_remote_datasource.dart';
import '../../data/repositories/device_db_repository_impl.dart';

class DeviceProvider extends ChangeNotifier {
  final findDevicesUsecase = 
    FindDevicesUsecase(BluetoothRepositoryImpl(BluetoothDatasource()));
  final openSettingsUsecase = 
    OpenSettingsUsecase();
  final connectDeviceUsecase = 
    ConnectDeviceUsecase(BluetoothRepositoryImpl(BluetoothDatasource()));
  final dowloadPreviewUsecase = 
    DowloadPreviewUsecase(BluetoothRepositoryImpl(BluetoothDatasource()));
  final disconnectUsecase = 
    DisconnectUsecase(BluetoothRepositoryImpl(BluetoothDatasource()));
  final uploadSettingUsecase = 
    UploadDeviceSettingUsecase(
      BluetoothRepositoryImpl(BluetoothDatasource()),
      DeviceDbRepositoryImpl(DeviceRemoteDatasource())
    );

  bool isLoading = false;

  // device loading
  bool isConnecting = false;
  bool isScaning = false;
  bool isLoadingData = false;

  String? error;
  BluetoothFailre? failre;

  // Deive
  List<DeviceEntity> devices = [];
  PreviewEntity? dataFromDevice;

  StreamSubscription? _devicesSub;
  StreamSubscription? _dataSub;

  // Database
  DeviceSettingEntity? deviceSetting;

  // ---------------
  // Find Device
  // ---------------
  Future<void> findDevices() async {
    error = null;
    failre = null;
    isScaning = true;
    
    devices = [];
    notifyListeners();
    try {
      _devicesSub = findDevicesUsecase.call().listen(
        (data) {
        devices = data;
        notifyListeners();
      },
      onDone: () async {
        await _devicesSub?.cancel();
        isScaning = false;
        notifyListeners();
      },
      onError: (e) {
        _devicesSub = null;
      }
      );

    } on BluetoothFailre catch (e) {
      failre = e;
      error = e.toString();
    } catch (e) {
      error = e.toString();
    }
  }

  // ---------------
  // Connect
  // ---------------
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

  // ---------------
  // Dowlaod Preview
  // ---------------
  Future<void> dowlaodPreview() async {
    error = null;
    isLoadingData = true;
    notifyListeners();
    try {
      _dataSub = dowloadPreviewUsecase.call().listen(
        (data) {
          dataFromDevice = data;
          notifyListeners();
      },
      onDone: () async {
        await _dataSub?.cancel();
        isLoadingData = false;
        notifyListeners();
      },
      onError: (e) {
        _dataSub = null;
      });
      
    } catch (e) {
      error = e.toString();
    }
  }

  // ---------------
  // Updaste Device Setting
  // ---------------
  Future<void> updateDeviceSetting(DeviceSettingEntity setting) async {
    error = null;
    isLoading = true;
    notifyListeners();
    try {
      deviceSetting = await uploadSettingUsecase.call(setting);
    } catch (e) {
      error = e.toString();
    }
    isLoading = false;
    notifyListeners();
  }

  // ---------------
  // Open App Setting
  // ---------------
  Future<void> openSetting() async {
    await openSettingsUsecase.call();
  }
}