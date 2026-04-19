import 'package:flexiback/core/exception/bluetooth_exception/bluetooth_error_type.dart';
import 'package:flexiback/features/device/presentation/controller/device_provider.dart';
import 'package:flexiback/shared/widgets/dialog/warn/dislog_warn.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DevicePage extends StatefulWidget {
  const DevicePage({super.key});

  @override
  State<DevicePage> createState() => _DevicePageState();
}

class _DevicePageState extends State<DevicePage> {

  @override
  void initState() {
    super.initState();

    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   final deviceProvider = context.
    // });
  }

  @override
  Widget build(BuildContext context) {
    final deviceProvider = context.watch<DeviceProvider>();

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: FilledButton(
            onPressed: () async {
              if (deviceProvider.isStream) return;

              await deviceProvider.findDevices();
              if (deviceProvider.failre != null) {
                switch(deviceProvider.failre!.type) {
        
                  case BluetoothErrorType.noPermission:
                    showWarnDialog(
                      context: context,
                      message: deviceProvider.error ?? '',
                      actionText: "open setting",
                      action: ()  async {
                        await deviceProvider.openSetting();
                      }
                    );
                    break;
        
                  case BluetoothErrorType.bluetoothoff:
                    showWarnDialog(
                      context: context,
                      message: deviceProvider.error ?? '',
                      actionText: "close",
                      action: () {
                        Navigator.pop(context);
                      }
                    );
                    break;
                }
              }else {
                print("Alllow");
              }
              
            },
            child: Text(
              deviceProvider.isStream ? "Findding the Devices..." : "Find the Devices"
            )
          ),
        ),

        Text(
          "Is Streaming : ${deviceProvider.isStream}"
        ),

        if (deviceProvider.devices.isEmpty) 
          Center(
            child: Text("No device"),
          )

        else if (deviceProvider.devices.isNotEmpty)
          Expanded(
            child: ListView.builder(
              itemCount: deviceProvider.devices.length,
              itemBuilder: (context,index) {
                return Column(
                  children: [
                    Text("Name : ${deviceProvider.devices[index].name ?? 'noname'}, Adress : ${deviceProvider.devices[index].address}"),
                    FilledButton(
                      onPressed: () async {
                        if (deviceProvider.isConnecting) return;
                        await deviceProvider.connect(deviceProvider.devices[index]);
                      },
                      child: Text("connect")
                    )
                  ],
                );
              },
              
            ),
          )
      ],
    );
  }
}