import 'package:flexiback/features/device/domain/entities/bt_connection_state.dart';

class DeviceEntity {
  final String? name;
  final String address;
  final BtConnectionState state;

  DeviceEntity({
    required this.name,
    required this.address,
    required this.state
  });

  bool get isConnected => state == BtConnectionState.connected;

}