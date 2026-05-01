import 'dart:async';
import 'dart:convert';

import 'package:flexiback/core/exception/bluetooth_exception/bluetooth_failure.dart';
import 'package:flexiback/core/exception/core_exception/core_error_failure.dart';
import 'package:flexiback/core/exception/device_exception/device_failure.dart';
import 'package:flexiback/features/device/data/models/device_model.dart';
import 'package:flexiback/features/device/domain/enums/bt_request.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

import '../../domain/enums/bt_connection_state.dart';
import '../../domain/enums/bt_response.dart';

class BluetoothDatasource {
  
  static final BluetoothDatasource _instance = BluetoothDatasource._();
  factory BluetoothDatasource() => _instance;
  BluetoothDatasource._();

  // Connection
  BluetoothConnection? _connection;
  BluetoothDevice? _connectedDevice;

  // Stream Controller 
  StreamController<String>? _dataController;
  StreamController<List<DeviceModel>>? _devicesDataController;
  final _stateController = StreamController<BtConnectionState>();

  // Get Stream
  Stream<List<DeviceModel>> get deviceStream {
    _devicesDataController ??= StreamController<List<DeviceModel>>.broadcast();
    return _devicesDataController!.stream;
  }

  Stream<String> get dataStream {
    _dataController ??= StreamController<String>.broadcast();
    return _dataController!.stream;
  }

  Stream<Uint8List>? _inputBroadcast;

  // Getters
  Stream<BtConnectionState> get stateStream => _stateController.stream;
  bool get isConnected => _connection?.isConnected ?? false;
  BluetoothDevice? get conntedDevice {
    if (!isConnected) return null;
    print("I HERE BIE :${_connectedDevice}");
    return _connectedDevice;
  }


  final List<DeviceModel> _devices = [];

  // ---------------
  // Find Data
  // ---------------

  StreamSubscription? _findSub;

  void findDevice() async {
    _devices.clear();

    if (_devicesDataController == null || _devicesDataController!.isClosed) {
      _devicesDataController = StreamController<List<DeviceModel>>.broadcast();
    }

    _findSub = FlutterBluetoothSerial.instance.startDiscovery().listen((result) {
      final device = DeviceModel.fromBtDevice(result.device);
      final exists = _devices.any((d) => d.address == device.address);
      
      if (!exists) {
        _devices.add(device);
        _devicesDataController!.add(List.unmodifiable(_devices));
      }
    },
    onDone: () {
      cancelFind();
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

    print("----- DEVICE ${device} -----");

    // state
    _stateController.add(BtConnectionState.connecting);

    try {
      _connection = await BluetoothConnection
                    .toAddress(device.address)
                    .timeout(const Duration(seconds: 15));

      _inputBroadcast = _connection!.input!.asBroadcastStream();

      _connectedDevice = device;

      // state
      _stateController.add(BtConnectionState.connected);

      print("Connected to ${_connectedDevice!.address}");
      print("IS CONECTED ${isConnected}");
      print("----- CON DEVICE ${_connectedDevice} -----");
      
      return true;
      
    } on TimeoutException {
      // state
      _stateController.add(BtConnectionState.error);
      throw DeviceFailure.timOut();
    } catch (e) {
      print("I HERE: ${e.toString()}");
      // state
      _stateController.add(BtConnectionState.error);
      throw CoreFailure.unknown(e.toString());
    }
  }

  // ---------------s
  // Send to Device
  // ---------------
  Future<bool> sendString(String text) async {
    if (!isConnected) {
      throw BluetoothFailre.noConnection();
    };

    try {
      _connection!.output.add(
        Uint8List.fromList(utf8.encode("$text"))
      );

      await _connection!.output.allSent;
      return true;
    } catch (_) {
      throw DeviceFailure.sendError();
    }
  }

  Future<bool> sendRequest(BtRequest request) async {
    if (!isConnected) {
      throw BluetoothFailre.noConnection();
    };

    try {
      final  reault = await sendString(request.method);

      return reault;
    } catch (_) {
      rethrow;
    }
  }

  // ---------------
  // Listen the response
  // ---------------
  StreamSubscription? _dowloadSub;
  String _buffer = '';

  void startListening(BtRequest? request) {
    print("Start Stream");

    print("data con ; ${_dataController}");
    print("data sub ; ${_dowloadSub}");

    if (_dataController == null || _dataController!.isClosed) {
      _dataController = StreamController<String>.broadcast();
    }
    _buffer = ''; // reset buffer before each new listen session
    int startIndex = 0;
    int endIndex = 0;

    _dowloadSub = _inputBroadcast!.listen(
      (Uint8List data) {
        // _buffer += utf8.decode(data);
        if (request == null) {
          if (utf8.decode(data).trim() != '') {
            
            _dataController!.add(utf8.decode(data).trim()); 
          }
        }
        print("-- : ${utf8.decode(data)}");

        if (request != null) {
          _buffer += utf8.decode(data);
          if (_buffer.contains(request.start!)) {
            startIndex = _buffer.indexOf(request.start!);
            // final line = _buffer.substring(0, idx).trim();
            _buffer = _buffer.substring(startIndex + request.start!.length).trim();
            // if (line.isNotEmpty) _dataController!.add(line); 
            print("START Buffer : $_buffer");

          }
          if (_buffer.contains(request.end!)) {
            endIndex = _buffer.indexOf(request.end!);
            final result = _buffer.substring(0, endIndex).trim();

            _buffer = '';
            startIndex = 0;
            endIndex = 0;

            print("FINAL Buffet : $result");

            if (result.isNotEmpty) {
              _dataController!.add(result);
            }
            stopListening(); 
          }
        }
          // if (_buffer.contains(request.end)) {
          //   // final lastLine = _buffer.substring(0,_buffer.indexOf(BtResponse.end.entity)).trim();
          //   if (lastLine.isNotEmpty) _dataController!.add(lastLine);
          //   stopListening(); 
          // }

      },
      onDone: () {
        print("DONE ------- ");
        _stateController.add(BtConnectionState.disconnected);
        _connectedDevice = null;
        _buffer = '';
        stopListening();
      },
      onError: (e) {
        print(e.toString());
        _stateController.add(BtConnectionState.error);
        stopListening();
      }
    );
  }


  Future<void> stopListening() async {
    await _dowloadSub?.cancel();
    _dowloadSub = null;

    await _dataController?.close();
    _dataController = null;
    _buffer = '';

    print("STOPED");
  }


  // ---------------
  // Cancel
  // ---------------
  Future<void> cancelFind() async {
    await _devicesDataController?.close();
    _devicesDataController = null;

    await _findSub?.cancel();
    _findSub = null;
    
    print("Cancel success");
  }

  Future<void> disconnect() async {
    await _connection?.close();
    _connection = null;
    _connectedDevice = null;
    
    _stateController.add(BtConnectionState.disconnected);
    
  }

  // ---------------
  // Dispose
  // ---------------
  Future<void> dispose() async {
    // finding data service
    await _devicesDataController?.close();
    _devicesDataController = null;

    // dowload data service
    await  _dowloadSub?.cancel();
    _dowloadSub = null;
    
    await _dataController?.close();
    _dataController = null;

    // state stream
    await _stateController.close;

    _devices.clear();
    await _findSub?.cancel();

    _connection?.dispose();
    _connectedDevice = null;

    
  }

}