import 'dart:async';
import 'dart:convert';

import 'package:flexiback/core/exception/bluetooth_exception/bluetooth_failure.dart';
import 'package:flexiback/core/exception/core_exception/core_error_failure.dart';
import 'package:flexiback/core/exception/device_exception/device_failure.dart';
import 'package:flexiback/features/device/data/models/device_model.dart';
import 'package:flexiback/features/device/domain/entities/bt_request.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

import '../../domain/entities/bt_connection_state.dart';
import '../../domain/entities/bt_response.dart';

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
      throw DeviceFailure.timOut();
    } catch (e) {
      _stateController.add(BtConnectionState.error);
      throw CoreFailure.unknown(e.toString());
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
      throw DeviceFailure.sendError();
    }
  }

  Future<bool> sendRequest(BtRequest request) async {
    if (!isConnected) return false;
    try {
      await sendString(request.entity);

      return true;
    } catch (_) {
      rethrow;
    }
  }

  // ---------------
  // Listen the response
  // ---------------
  StreamSubscription? _dowloadSub;
  String _buffer = '';

  void startListening() {
    _dowloadSub = _connection!.input!.listen(
      (Uint8List data) {
        _buffer += utf8.decode(data);

        while (_buffer.contains(BtResponse.newLine.entity)) {
          final idx = _buffer.indexOf(BtResponse.newLine.entity);
          final line = _buffer.substring(0, idx).trim();
          _buffer = _buffer.substring(idx+1);
          if (line.isNotEmpty) _dataController.add(line); 
        }

        if (_buffer.contains(BtResponse.end.entity)) {
          final lastLine = _buffer.substring(0,_buffer.indexOf(BtResponse.end.entity)).trim();
          if (lastLine.isNotEmpty) _dataController.add(lastLine);
          _stopListening(); 
        }

      },
      onDone: () {
        _stateController.add(BtConnectionState.disconnected);
        _connectedDevice = null;
        _buffer = '';
      },
      onError: (e) {
        _stateController.add(BtConnectionState.error);
        _stopListening();
      }
    );
  }

  void _stopListening() {
    _dowloadSub?.cancel();
    _dowloadSub = null;
    _buffer = '';
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