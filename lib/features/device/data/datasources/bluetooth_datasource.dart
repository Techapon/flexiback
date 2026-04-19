import 'dart:async';
import 'dart:convert';

import 'package:flexiback/features/device/data/models/device_model.dart';
import 'package:flexiback/features/device/domain/entities/bt_request.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

import '../../domain/entities/bt_connection_state.dart';

class BluetoothDatasource {
  
  static final BluetoothDatasource _instance = BluetoothDatasource._();
  factory BluetoothDatasource() => _instance;
  BluetoothDatasource._();

  // Connection
  BluetoothConnection? _connection;
  BluetoothDevice? _connectedDevice;

  // Stream Controller 
  final _dataController = StreamController<String>.broadcast();
  StreamController<List<DeviceModel>>? _devicesDataController;
  final _stateController = StreamController<BtConnectionState>();
  Stream<List<DeviceModel>> get deviceStream {
    _devicesDataController ??= StreamController<List<DeviceModel>>.broadcast();
    return _devicesDataController!.stream;
  }

  // Getters
  Stream<String> get dataStream => _dataController.stream;
  Stream<BtConnectionState> get stateStream => _stateController.stream;
  bool get isConnected => _connection?.isConnected ?? false;
  BluetoothDevice? get conntedDevice => _connectedDevice;


  final List<DeviceModel> _devices = [];


  // ---------------
  // Find Data
  // ---------------
  void findDevice() {
    _devices.clear();

    if (_devicesDataController == null || _devicesDataController!.isClosed) {
      _devicesDataController = StreamController<List<DeviceModel>>.broadcast();
    }

    FlutterBluetoothSerial.instance.startDiscovery().listen((result) {
      final device = DeviceModel.fromBtDevice(result.device);
      final exists = _devices.any((d) => d.address == device.address);

      if (!exists) {
        _devices.add(device);
        _devicesDataController!.add(List.unmodifiable(_devices));
      }
    },
    onDone: () {
      dispose();
    },
    onError: (e) {
      _devicesDataController!.addError(e);
    }
    );
  }

  // ---------------
  // Connect Device
  // ---------------
  Future<bool> connect(BluetoothDevice device) async{
    if (isConnected) await disconnect();

    _stateController.add(BtConnectionState.connecting);

    try {
      _connection = await BluetoothConnection
                    .toAddress(device.address)
                    .timeout(const Duration(seconds: 15));

      _connectedDevice = device;
      _stateController.add(BtConnectionState.connected);

      print("Connected to ${_connectedDevice!.address}");
      
      return true;

    } on TimeoutException {
      _stateController.add(BtConnectionState.error);
      rethrow;
    } catch (e) {
      _stateController.add(BtConnectionState.error);
      rethrow;
    }
  }

  // ---------------
  // Send to Device
  // ---------------
  Future<bool> sendString(String text) async {
    if (!isConnected) return false;
    try {
      _connection!.output.add(
        Uint8List.fromList(utf8.encode("$text\n"))
      );

      await _connection!.output.allSent;
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> sendRequest(BtRequest request) async {
    if (!isConnected) return false;
    try {
      final result = await sendString(request.entity);

      if (result) {

      }

      return true;
    } catch (_) {
      return false;
    }
  }

  // ---------------
  // Listen the response
  // ---------------
  String _buffer = '';

  void _startListening(BtRequest request) {
    _connection!.input!.listen(
      (Uint8List data) {

      },
      onDone: () {
        _stateController.add(BtConnectionState.disconnected);
        _connectedDevice = null;
        _buffer = '';
      },
      onError: (e) {
        _stateController.add(BtConnectionState.error);
      }
    );
  }



  // ---------------
  // Helper
  // ---------------
  Future<void> disconnect() async {
    await _connection?.close();
    _connection = null;
    _connectedDevice = null;
    
    _stateController.add(BtConnectionState.disconnected);
  }

  void dispose() {
    _devicesDataController?.close();
    _dataController?.close();
    _connection?.dispose();
  }

}