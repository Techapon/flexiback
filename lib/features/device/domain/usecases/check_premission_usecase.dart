import '../../../../core/exception/bluetooth_exception/bluetooth_failure.dart';
import '../services/bluetooth_permission/bluetooth_permission.dart';

class CheckPremissionUsecase {

  Future<void> call() async {
    final bool permission = await BluetoothPermission.requestPermissions();
    if (!permission) {
      throw BluetoothFailre.noPermission();
    }

    final bool isopenBluetooth = await BluetoothPermission.isBluetoothEnabled();
    if (!isopenBluetooth) {
      final openBtRequest = await BluetoothPermission.enableBluetooth();

      if (!openBtRequest) {
        throw BluetoothFailre.bluetoothOff();
      }
    }
  }
}