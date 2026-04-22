import 'dart:async';

import 'package:flexiback/core/exception/bluetooth_exception/bluetooth_failure.dart';
import 'package:flexiback/features/device/data/datasources/bluetooth_datasource.dart';
import 'package:flexiback/features/device/data/repositories/bluetooth_repository_impl.dart';
import 'package:flexiback/features/device/domain/entities/device_entity.dart';
import 'package:flexiback/features/device/domain/entities/device_setting_entity.dart';
import 'package:flexiback/features/device/domain/entities/full_data_entity.dart';
import 'package:flexiback/features/device/domain/entities/preview_entity.dart';
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
import '../../domain/usecases/check_premission_usecase.dart';
import '../../domain/usecases/dowload_fulldata_usecase.dart';

class DeviceProvider extends ChangeNotifier {
  final findDevicesUsecase = 
    FindDevicesUsecase(BluetoothRepositoryImpl(BluetoothDatasource()));
  final openSettingsUsecase = 
    OpenSettingsUsecase();
  final connectDeviceUsecase = 
    ConnectDeviceUsecase(BluetoothRepositoryImpl(BluetoothDatasource()));
  final checkPremissionUsecase = CheckPremissionUsecase();

  final dowloadPreviewUsecase = 
    DowloadPreviewUsecase(BluetoothRepositoryImpl(BluetoothDatasource()));
  final dowloadFullUsecase = 
    DowloadFulldataUsecase(
      BluetoothRepositoryImpl(BluetoothDatasource()),
      DeviceDbRepositoryImpl(DeviceRemoteDatasource())
    );

  final disconnectUsecase = 
    DisconnectUsecase(BluetoothRepositoryImpl(BluetoothDatasource()));
  final uploadSettingUsecase = 
    UploadDeviceSettingUsecase(
      BluetoothRepositoryImpl(BluetoothDatasource()),
      DeviceDbRepositoryImpl(DeviceRemoteDatasource())
    );

  bool isLoading = false;

  // device loading
  bool isChecking = false;
  bool isScaning = false;
  bool isConnecting = false;
  bool isLoadingData = false;

  String? error;
  BluetoothFailre? failre;

  // Device
  List<DeviceEntity> devices = [];

  // preview
  StreamSubscription? _devicesSub;
  PreviewEntity? dataFromDevice;

  // full data
  StreamSubscription? _dataSub;
  FullDataEntity? fulldata;

  // Database
  DeviceSettingEntity? deviceSetting;

  void dispose() {
    
  }

  // ---------------
  // Check Permission
  // ---------------
  Future<void> checkPer() async {
    error = null;
    failre = null;
    
    isChecking = true;
    notifyListeners();

    try {
      await checkPremissionUsecase.call();
    } on BluetoothFailre catch (e) {
      failre = e;
      error = e.toString();
    }

    isChecking = false;
    notifyListeners();
  } 

  // ---------------
  // Find Device
  // ---------------
  Future<void> findDevices() async {
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
  // Dowlaod Full Data
  // ---------------
  Future<void> dowlaodFullData() async {
    error = null;
    isLoadingData = true;
    notifyListeners();
    try {
      final streamData = dowloadFullUsecase.call();
      await for (final data in streamData) {
        fulldata = data;
        notifyListeners();
      }

      print(fulldata.toString());

      isLoading = false;
      notifyListeners();
    } catch (e) {
      error = e.toString();
      isLoading = false;
      notifyListeners();
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