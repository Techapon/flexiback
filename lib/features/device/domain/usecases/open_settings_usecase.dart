import 'package:flexiback/features/device/domain/services/bluetooth_permission/bluetooth_permission.dart';

class OpenSettingsUsecase {
  Future<void> call() async {
    await BluetoothPermission.openSettings();
  }
}