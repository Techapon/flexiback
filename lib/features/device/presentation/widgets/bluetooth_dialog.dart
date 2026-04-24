import 'package:flexiback/config/theme/colors/app_color.dart';
import 'package:flexiback/shared/widgets/dialog/error/dialog_error.dart';
import 'package:flexiback/shared/widgets/dialog/success/dialog_success.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';

import '../controller/device_provider.dart';

class BluetoothDialog extends StatefulWidget {
  const BluetoothDialog({super.key,});

  @override
  State<BluetoothDialog> createState() => _BluetoothDialogState();
}

class _BluetoothDialogState extends State<BluetoothDialog> {
  late DeviceProvider _deviceProvider;

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      _deviceProvider = context.read<DeviceProvider>();
    });
  }

  @override
  void dispose() {
    
    _deviceProvider.calcelFind();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final deviceProvider = context.watch<DeviceProvider>();

    return Dialog(
      backgroundColor: AppColor.base1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24)
      ),
      child: Padding(
        padding: EdgeInsets.only(
          top: 16,
          right: 32,
          left: 32,
          bottom: deviceProvider.isScaning ? 48 : 32
        ),
        child: Column(
          spacing: 32,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 4,
              width: 80,
              decoration: BoxDecoration(
                color: AppColor.grey1,
                borderRadius: BorderRadius.circular(8)
              ),
            ),
      
            Column(
              spacing: 16,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (!(deviceProvider.devices.isEmpty && !deviceProvider.isScaning))
                  Container(
                    padding: EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(32),
                      gradient: LinearGradient(
                        colors: [
                          AppColor.blue3,
                          AppColor.blue4,
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColor.black1.withOpacity(.25),
                          offset: Offset(0, 7.5),
                          blurRadius: 10,
                          spreadRadius : 1
                        )
                      ]
                    ),
                    child: Icon(
                      LucideIcons.bluetooth,
                      color: AppColor.base1.withOpacity(.75),
                      size: 40,
                    ),
                  ),
      
                Column(
                  spacing: 4,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      deviceProvider.devices.isEmpty && !deviceProvider.isScaning
                        ? "Device not found"
                        : deviceProvider.isScaning 
                          ? "Searching..."
                          : "Let's connect" ,
                      style: TextStyle(
                        color: AppColor.black1,
                        fontSize: 22,
                        fontWeight: FontWeight.w600
                      ),
                    ),
      
                    Text(
                      deviceProvider.devices.isEmpty && !deviceProvider.isScaning
                        ? "Make sure the device is close to your phone. Please try again"
                        : deviceProvider.isScaning 
                          ? "Please waiting for searching device"
                          : "Choose your device and conncet",
                      style: TextStyle(
                        color: AppColor.grey3,
                        fontSize: 12,
                      ),
                      textAlign: TextAlign.center,
                    )
                  ],
                )
              ],
            ),

            if (deviceProvider.devices.isEmpty && !deviceProvider.isScaning)
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColor.blue1, 
                  side: BorderSide(
                    color: AppColor.blue1, 
                    width: 2,         
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16), 
                  ),
                ),
                onPressed: () {
                  deviceProvider.findDevices();
                },
                child: Text(
                  "try again"
                )
              ),

      
            // Device List
            if (deviceProvider.devices.isNotEmpty)
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: 300,
                  minHeight: 0
                ),
                child: ListView.separated(
                  shrinkWrap: true,
                  separatorBuilder: (context, index) => SizedBox(height: 8),
                  itemCount: deviceProvider.devices.length,
                  itemBuilder: (context,index) {
                    return GestureDetector(
                      onTap: () async {
                        if (deviceProvider.isConnecting) return;

                        await deviceProvider.connect(deviceProvider.devices[index]);

                        if (deviceProvider.error == null) {
                          showErrorDialog(
                            context: context,
                            message: deviceProvider.error!
                          );
                        } else {
                          showSuccessDialog(
                            context: context,
                            message: "Connect to '${deviceProvider.devices[index].name}' successfully!"
                          );
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColor.base3,
                          borderRadius: BorderRadius.circular(18)
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              spacing: 8,
                              children: [
                                Container(
                                  padding: EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color : AppColor.base1,
                                    borderRadius: BorderRadius.circular(10)
                                  ),
                                  child: Image.asset(
                                    "assets/images/device_logo.png",
                                    height: 27.5,
                                  ),
                                ),
                      
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      deviceProvider.devices[index].name ?? "Don't have ",
                                      style: TextStyle(
                                        color: AppColor.black1,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold
                                      ),
                                    ),
                                    Text(
                                      deviceProvider.devices[index].address,
                                      style: TextStyle(
                                        color: AppColor.grey3,
                                        fontSize: 12,
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                      
                            Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                gradient: LinearGradient(
                                  colors: [
                                    AppColor.blue3,
                                    AppColor.blue4,
                                  ],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ),
                              ),
                              child: Icon(
                                Icons.arrow_forward_ios_rounded,
                                color: AppColor.base1,
                                size: 14,
                              ),
                            ),
                          ],
                        )
                      ),
                    );
                  }
                ),
              ),
          ],
        ),
      ),
    );
  }
}