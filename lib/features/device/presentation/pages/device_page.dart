import 'package:dotted_border/dotted_border.dart';
import 'package:flexiback/features/device/presentation/controller/device_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';

import '../../../../config/theme/colors/app_color.dart';
import '../../../../core/exception/bluetooth_exception/bluetooth_error_type.dart';
import '../../../../shared/navigation/items/geneeral_items.dart';
import '../../../../shared/widgets/dialog/warn/dislog_warn.dart';
import '../widgets/bluetooth_dialog.dart';
import '../widgets/device_content.dart';

class DevicePage extends StatefulWidget {
  final Function(GeneeralMainTap)? setCurrent;
  const DevicePage({
    super.key,
    this.setCurrent
  });

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

    // return Column(
    //   mainAxisAlignment: MainAxisAlignment.center,
    //   children: [
    //     Center(
    //       child: FilledButton(
    //         onPressed: () async {
    //           if (deviceProvider.isScaning) return;

              // await deviceProvider.findDevices();
              // if (deviceProvider.failre != null) {
              //   switch(deviceProvider.failre!.type) {
        
              //     case BluetoothErrorType.noPermission:
              //       showWarnDialog(
              //         context: context,
              //         message: deviceProvider.error ?? '',
              //         actionText: "open setting",
              //         action: ()  async {
              //           await deviceProvider.openSetting();
              //         }
              //       );
              //       break;
        
              //     case BluetoothErrorType.bluetoothoff:
              //       showWarnDialog(
              //         context: context,
              //         message: deviceProvider.error ?? '',
              //         actionText: "close",
              //         action: () {
              //           Navigator.pop(context);
              //         }
              //       );
              //       break;
                  
              //     default:
              //       break;
              //   }
              // }else {
              //   print("Alllow");
              // }
              
    //         },
    //         child: Text(
    //           deviceProvider.isScaning ? "Findding the Devices..." : "Find the Devices"
    //         )
    //       ),
    //     ),

    //     Text(
    //       "Is Streaming : ${deviceProvider.isScaning}"
    //     ),

    //     if (deviceProvider.devices.isEmpty) 
    //       Center(
    //         child: Text("No device"),
    //       )

    //     else if (deviceProvider.devices.isNotEmpty)
    //       Expanded(
    //         child: ListView.builder(
    //           itemCount: deviceProvider.devices.length,
    //           itemBuilder: (context,index) {
    //             return Column(
    //               children: [
    //                 Text("Name : ${deviceProvider.devices[index].name ?? 'noname'}, Adress : ${deviceProvider.devices[index].address}"),
    //                 FilledButton(
    //                   onPressed: () async {
    //                     if (deviceProvider.isConnecting) return;
    //                     await deviceProvider.connect(deviceProvider.devices[index]);
    //                   },
    //                   child: Text("connect")
    //                 )
    //               ],
    //             );
    //           },
              
    //         ),
    //       )
    //   ],
    // );

    return  Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 8
          ),
          child: Column(
            spacing: 16,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              // Head
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Text(
                        "FLEXIBACK",
                        style: GoogleFonts.paytoneOne(
                          fontSize: 26,
                          wordSpacing: 4,
                          foreground: Paint()..shader = LinearGradient(
                            colors:AppColor.mainGradientColrs
                          ).createShader(Rect.fromLTWH(0, 0, 100, 70))
                        ),
                      ),

                      Positioned(
                        right: -47.5,
                        child: Image.asset(
                          'assets/emoji/fox.png',
                          height: 37.5,
                        ),
                      )
                    ],
                  ),
                ],
              ),

              DottedBorder(
                color: AppColor.grey2,    
                strokeWidth: 1.5,       
                dashPattern: [8, 4],  
                borderType: BorderType.RRect,
                radius: Radius.circular(18),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                  ),
                  child: Column(
                    spacing: 16,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        spacing: 8,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Opacity(
                            opacity: 0.25,
                            child: Image.asset(
                              "assets/device/flexiback_outline.png",
                              height: 115,
                            ),
                          ),
                
                          Text(
                            "Let's Connect!",
                            style: GoogleFonts.paytoneOne(
                              color: AppColor.black1,
                              fontSize: 24
                            ),
                          ),
                
                          Text(
                            "Find a device to configure and download data",
                            style: TextStyle(
                              color: AppColor.grey3,
                              fontSize: 14
                            ),
                          ),
                        ],
                      ),
                
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors:AppColor.mainGradientColrs
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: FilledButton(
                          style: FilledButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            backgroundColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () async {
                            if (deviceProvider.isChecking || deviceProvider.isScaning) return;
                            
                            await deviceProvider.checkPer();
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
                                
                                default:
                                  break;
                              }
                            }else {
                              deviceProvider.findDevices();
                              print("No-Problem");
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return BluetoothDialog();
                                }
                              );
                            }
                            
                          },
                          child: Row(
                            spacing: 4,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                LucideIcons.plus,
                                color: AppColor.base1,
                                size: 22,
                              ),
                        
                              Text(
                                deviceProvider.isChecking 
                                  ? "Checking Permission..." 
                                  : "Search for device",
                                style: TextStyle(
                                  color:AppColor.base1,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold
                                ),
                              )
                            ],
                          )
                        ),
                      ),                      
                    ],
                  )
                ),
              ),
 
              // Usage
              Container(
                width: double.infinity,
                padding: EdgeInsets.only(
                  right: 8,
                  left: 16,
                  top: 8,
                  bottom: 8,
                ),
                decoration: BoxDecoration(
                  color: AppColor.base1,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(18),
                    topRight: Radius.circular(18),
                    bottomLeft: Radius.circular(18),
                    bottomRight: Radius.circular(32),
                  ),
                  border: Border.all(
                    width: 1.5,
                    color: AppColor.grey2
                  )
                ),
                child: Stack(
                  children: [
                    Column(
                      spacing: 8,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Usage',
                          style: GoogleFonts.paytoneOne(
                            color: AppColor.black1,
                            fontSize: 26
                          ),
                        ),

                        Text(
                          "you have no device usage...",
                          style: TextStyle(
                            color: AppColor.grey3
                          ),
                        ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors:AppColor.mainGradientColrs
                                ),
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(16),
                                  topRight: Radius.circular(8),
                                  bottomLeft: Radius.circular(16),
                                  bottomRight: Radius.circular(26),
                                ),
                              ),
                              child: FilledButton(
                                style: FilledButton.styleFrom(
                                  padding: EdgeInsets.symmetric(vertical: 6,horizontal: 32),
                                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  minimumSize: Size.zero,
                                  backgroundColor: Colors.transparent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                onPressed: () {
                                  widget.setCurrent!(GeneeralMainTap.trend);
                                },
                                child: Text(
                                  "more",
                                  style: TextStyle(
                                    letterSpacing: 1,
                                    color:AppColor.base1,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold
                                  ),
                                )
                              ),
                            )
                          ],
                        )
                      ],
                    ),

                    Positioned(
                      right: 0,
                      child: Image.asset(
                        "assets/emoji/lighting.png",
                        height: 25,
                      ),
                    )
                  ],
                ),
              ),

              // Progress & Setting
              Row(
                spacing: 16,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(
                    flex: 5,
                    child: DeviceContent(
                      title: "Progress",
                      imagPath: "assets/images/graph.png", 
                      btnText: "view progress",
                      onTap: () {
                        widget.setCurrent!(GeneeralMainTap.trend);
                      },
                    )
                  ),

                  Flexible(
                    flex: 4,
                    child: DeviceContent(
                      title: "Setting",
                      imagPath: "assets/emoji/setting.png", 
                      btnText: "setting device",
                      onTap: () {

                      },
                    )
                  )
                ],
              )
            ],
          ),
        )
      ),
    );
  }
}