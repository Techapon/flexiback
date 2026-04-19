import 'package:flexiback/core/exception/bluetooth_exception/bluetooth_failure.dart';
import 'package:flexiback/features/device/data/datasources/bluetooth_datasource.dart';
import 'package:flexiback/features/device/data/models/device_model.dart';
import 'package:flexiback/features/device/domain/entities/device_entity.dart';
import 'package:flexiback/features/device/domain/repositories/bluetooth_repository.dart';

class BluetoothRepositoryImpl implements BluetoothRepository {
  final BluetoothDatasource datasource;

  BluetoothRepositoryImpl(this.datasource);

  @override
  Stream<List<DeviceEntity>> findDeivce() {
    datasource.findDevice();

    return datasource.deviceStream
      .map(
        (models) => models.map((m) => m.toEntity()).toList()
      )
      .handleError((e) {
        throw BluetoothFailre.bluetoothOff();
      });
  }

  @override
  Future<bool> connectDevice(DeviceEntity device) {
    return datasource.connect(
      DeviceModel.fromEntity(device).toBtDevice()
    );
  }

  

}