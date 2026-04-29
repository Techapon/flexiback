import 'dart:async';

import 'package:flexiback/core/exception/bluetooth_exception/bluetooth_failure.dart';
import 'package:flexiback/features/device/data/datasources/bluetooth_datasource.dart';
import 'package:flexiback/features/device/data/repositories/bluetooth_repository_impl.dart';
import 'package:flexiback/features/device/domain/entities/device_entity.dart';
import 'package:flexiback/features/device/domain/entities/device_setting_entity.dart';
import 'package:flexiback/features/device/domain/entities/full_data_entity.dart';
import 'package:flexiback/features/device/domain/entities/preview_entity.dart';
import 'package:flexiback/features/device/domain/enums/bt_connection_state.dart';
import 'package:flexiback/features/device/domain/usecases/cancel_find_usecase.dart';
import 'package:flexiback/features/device/domain/usecases/connect_device_usecase.dart';
import 'package:flexiback/features/device/domain/usecases/disconnect_usecase.dart';
import 'package:flexiback/features/device/domain/usecases/dispose_usecase.dart';
import 'package:flexiback/features/device/domain/usecases/dowload_preview_usecase.dart';
import 'package:flexiback/features/device/domain/usecases/find_devices_usecase.dart';
import 'package:flexiback/features/device/domain/usecases/get_device_setting_usecase.dart';
import 'package:flexiback/features/device/domain/usecases/get_device_usecase.dart';
import 'package:flexiback/features/device/domain/usecases/open_settings_usecase.dart';
import 'package:flexiback/features/device/domain/usecases/state_stream_usecase.dart';
import 'package:flexiback/features/device/domain/usecases/upload_device_setting_usecase.dart';
import 'package:flutter/material.dart';

import '../../data/datasources/device_remote_datasource.dart';
import '../../data/repositories/device_db_repository_impl.dart';
import '../../domain/usecases/check_premission_usecase.dart';
import '../../domain/usecases/dowload_fulldata_usecase.dart';

class DeviceProvider extends ChangeNotifier {
  // Connection
  final findDevicesUsecase = 
    FindDevicesUsecase(BluetoothRepositoryImpl(BluetoothDatasource()));
  final connectDeviceUsecase = 
    ConnectDeviceUsecase(BluetoothRepositoryImpl(BluetoothDatasource()));

  // Getter
  final dowloadPreviewUsecase = 
    DowloadPreviewUsecase(BluetoothRepositoryImpl(BluetoothDatasource()));
  final dowloadFullUsecase = 
    DowloadFulldataUsecase(
      BluetoothRepositoryImpl(BluetoothDatasource()),
      DeviceDbRepositoryImpl(DeviceRemoteDatasource())
    );
  final getDeviceUsecase =
    GetDeviceUsecase(BluetoothRepositoryImpl(BluetoothDatasource()));
  final getDeviceSettingUsecase =
    GetDeviceSettingUsecase(DeviceDbRepositoryImpl(DeviceRemoteDatasource()));
  final stateStreamUsecase = 
    StateStreamUsecase(BluetoothRepositoryImpl(BluetoothDatasource()));

  // Setting
  final openSettingsUsecase = 
    OpenSettingsUsecase();

  // Permission
  final checkPremissionUsecase = CheckPremissionUsecase();

  // Upload
  final uploadSettingUsecase = 
    UploadDeviceSettingUsecase(
      BluetoothRepositoryImpl(BluetoothDatasource()),
      DeviceDbRepositoryImpl(DeviceRemoteDatasource())
    );

  // Dispose
  final disposeUsecase = 
    DisposeUsecase(BluetoothRepositoryImpl(BluetoothDatasource()));
  final cancelFindUsecase = 
    CancelFindUsecase(BluetoothRepositoryImpl(BluetoothDatasource()));
  final disconncetUsecase = 
    DisconnectUsecase(BluetoothRepositoryImpl(BluetoothDatasource()));

  bool isLoading = false;

  // device loading
  bool isChecking = false;
  bool isScaning = false;
  bool isConnecting = false;
  bool isLoadingData = false;

  // getter
  bool get isConnected => state == BtConnectionState.connected;
  DeviceEntity? get connectedDevice => _connectedDevice;

  String? error;
  BluetoothFailre? failre;

  // Device
  List<DeviceEntity> devices = [];
  DeviceEntity? _connectedDevice;

  DeviceSettingEntity? deviceSetting;
 
  // state
  StreamSubscription? _stateSub;
  BtConnectionState state = BtConnectionState.disconnected;

  // preview
  StreamSubscription? _devicesSub;
  PreviewEntity? dataFromDevice;

  // full data
  StreamSubscription? _dataSub;
  FullDataEntity? fulldata;

  // Database

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
  // State
  // ---------------
  Future<void> getState() async {
    try {
      _stateSub = stateStreamUsecase.call().listen(
        (data) {
        state = data;
        
        notifyListeners();
      },
      onDone: () async {
        await _stateSub?.cancel();
        notifyListeners();
      },
      onError: (e) {
        _stateSub = null;
      }
      );
    } catch (e) {
      error = e.toString();
    }
  }

  // ---------------
  // Connected Device
  // ---------------
  void getDevice() {
    _connectedDevice = getDeviceUsecase.call();
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
      await connectDeviceUsecase.call(device);
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
        isLoadingData = false;
        notifyListeners();
      });
      
    } catch (e) {
      error = e.toString();
      isLoadingData = false;
      notifyListeners();
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
  // Get Device Setting
  // ---------------
  Future<void> getDeviceSetting() async {
    error = null;
    isLoading = true;
    notifyListeners();
    try {
      deviceSetting = await getDeviceSettingUsecase.call();
    } catch (e) {
      error = e.toString();
    }
    isLoading = false;
    notifyListeners();
  }

  // ---------------
  // Update Device Setting
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

  // ---------------
  // Dispose
  // ---------------
  Future<void> disposeBluetooth() async {
    await disposeUsecase.call();
    notifyListeners();
  }

  Future<void> cancelFind() async {
    await cancelFindUsecase.call();
    notifyListeners();
  }

  Future<void> disconnect() async {
    await disconncetUsecase.call();
    notifyListeners();
  }
}