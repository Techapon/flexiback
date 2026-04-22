import 'package:flexiback/config/theme/colors/app_color.dart';
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
  

  @override
  void dispose() {
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
                      deviceProvider.isScaning 
                        ? "Searching..."
                        : "Let's connect" ,
                      style: TextStyle(
                        color: AppColor.black1,
                        fontSize: 22,
                        fontWeight: FontWeight.w600
                      ),
                    ),
      
                    Text(
                      deviceProvider.isScaning 
                        ? "Please waiting for searching device"
                        : "Choose your device and conncet",
                      style: TextStyle(
                        color: AppColor.grey3,
                        fontSize: 12
                      ),
                    )
                  ],
                )
              ],
            ),
      
            // Device List
            if (deviceProvider.devices.isEmpty)
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: 300,
                  minHeight: 0
                ),
                child: ListView.separated(
                  shrinkWrap: true,
                  separatorBuilder: (context, index) => SizedBox(height: 8),
                  itemCount: 2,
                  itemBuilder: (context,index) {
                    return Container(
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
                    );
                  }
                ),
              )
          ],
        ),
      ),
    );
  }
}