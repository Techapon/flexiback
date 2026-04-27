import 'dart:ui';

import 'package:dotted_border/dotted_border.dart';
import 'package:flexiback/config/router/routes.dart';
import 'package:flexiback/features/device/presentation/controller/daily_progress_provider.dart';
import 'package:flexiback/features/device/presentation/controller/device_provider.dart';
import 'package:flexiback/features/device/presentation/widgets/device_setter.dart';
import 'package:flexiback/features/device/presentation/widgets/gradient_button.dart';
import 'package:flexiback/features/device/presentation/widgets/preview_comfirm.dart';
import 'package:flexiback/shared/widgets/appbar/appbar1.dart';
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
  final Function(GeneralMainTap)? setCurrent;
  final String? userId;
  const DevicePage({
    super.key,
    this.setCurrent,
    this.userId
  });

  @override
  State<DevicePage> createState() => _DevicePageState();
}

class _DevicePageState extends State<DevicePage> {
  late DeviceProvider _deviceProvider;
  late DailyProgressProvider _dailyProvider;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _deviceProvider = context.read<DeviceProvider>();
      _deviceProvider.getState();

      // daily get data
      _dailyProvider = context.read<DailyProgressProvider>();
      _dailyProvider.getDailyProgress(widget.userId!);

    });
  }

  @override
  void dispose() {

    _deviceProvider.disposeBluetooth();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final deviceProvider = context.watch<DeviceProvider>();

    return  Scaffold(
      appBar: Appbar1(
        title: "flexiback",
        pathImag: "assets/emoji/fox.png"
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            bottom: 16
          ),
          child: SingleChildScrollView(
            child: Column(
              spacing: 16,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
             
                DottedBorder(
                  color: deviceProvider.isConnected ? Colors.transparent : AppColor.grey2,    
                  strokeWidth: 1.5,       
                  dashPattern: [8, 4],  
                  borderType: BorderType.RRect,
                  radius: Radius.circular(18),
                  child: Container(
                    width: double.infinity,
                    padding: deviceProvider.isConnected 
                      ? EdgeInsets.only(
                          left: 24,
                          right: 24,
                          top: 16,
                          bottom: 24
                        )
                      : EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: deviceProvider.isConnected ? null : Colors.transparent,
                      gradient: deviceProvider.isConnected ? LinearGradient(colors: AppColor.mainGradientColrs) : null,
                      borderRadius: BorderRadius.circular(24)
                    ),
                    child: Column(
                      spacing: 16,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          spacing: deviceProvider.isConnected ? 4 : 8,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [

                            Column(
                              spacing: 16,
                              children: [
                                if (deviceProvider.isConnected)
                                  Row(
                                    spacing: 4,
                                    children: [
                                      Icon(
                                        Icons.circle,
                                        color: AppColor.base1,
                                        size: 10,
                                      ),
                
                                      Text(
                                        "CONNECTED",
                                        style: TextStyle(
                                          color: AppColor.base1,
                                          fontSize: 12
                                        ),
                                      )
                                    ],
                                  ),

                                ClipRRect(
                                  borderRadius: BorderRadius.circular(18),
                                  child: BackdropFilter(
                                    filter: ImageFilter.blur(sigmaX: 50,sigmaY: 50),
                                    child: Container(
                                      width: double.infinity,
                                      padding: deviceProvider.isConnected 
                                        ? EdgeInsets.symmetric(vertical: 32)
                                        : null,
                                      decoration: deviceProvider.isConnected 
                                        ? BoxDecoration(
                                          color: AppColor.base1.withOpacity(.2),
                                          border: Border.all(
                                            color: AppColor.base2,
                                            width: .4
                                          ),
                                        )
                                        : null,
                                      child: Opacity(
                                        opacity: deviceProvider.isConnected ? 1 : 0.25,
                                        child: Image.asset(
                                          deviceProvider.isConnected 
                                            ? "assets/device/flexiback.png"
                                            : "assets/device/flexiback_outline.png",
                                          height: deviceProvider.isConnected ? 230 : 115,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            Column(
                              crossAxisAlignment: deviceProvider.isConnected ? CrossAxisAlignment.stretch : CrossAxisAlignment.center,
                              children: [
                                Text(
                                  deviceProvider.isConnected 
                                    ? deviceProvider.connectedDevice?.name ?? "Unknow"
                                    : "Let's Connect!",
                                  style: GoogleFonts.paytoneOne(
                                    color: deviceProvider.isConnected ? AppColor.base1 : AppColor.black1,
                                    fontSize: deviceProvider.isConnected ? 30 : 24
                                  ),
                                ),
                      
                                Text(
                                  deviceProvider.isConnected 
                                    ? "address : ${deviceProvider.connectedDevice?.address ?? "no address"}"
                                    : "Find a device to configure and download data",
                                  style: TextStyle(
                                    color: deviceProvider.isConnected ? AppColor.base1 : AppColor.grey3,
                                    fontSize: 14
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        
                        // Find device button
                        if (!deviceProvider.isConnected)
                          GradientButton(
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
                            ),
                            onTap: () async {
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
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return BluetoothDialog();
                                  }
                                );
                              }

                            },
                          ),

                        if (deviceProvider.isConnected)
                          FilledButton(
                            style: FilledButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 16),
                              backgroundColor: AppColor.base1,
                              foregroundColor: deviceProvider.connectedDevice != null
                                ? AppColor.grey2
                                : AppColor.error,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                              side: deviceProvider.connectedDevice == null
                                ? BorderSide(
                                  width: 2,
                                  color: AppColor.error
                                )
                                : null
                            ),
                            onPressed: 
                            deviceProvider.connectedDevice == null
                              ? () async {
                                await deviceProvider.disconnect();
                              }
                              : () {
                                // open previre data
                              },
                            child: Row(
                              spacing: 6,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                  Icon(
                                    deviceProvider.connectedDevice != null
                                      ? LucideIcons.arrowBigDownDash
                                      : Icons.warning_amber_rounded,
                                    color: deviceProvider.connectedDevice != null
                                      ? AppColor.black1
                                      : AppColor.error,
                                    size: 22,
                                  ),
                          
                                Text(
                                  deviceProvider.connectedDevice != null 
                                    ? "Dowload usage data"
                                    : "Click for reconncet",
                                  style: TextStyle(
                                    color:AppColor.black1,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold
                                  ),
                                )
                              ],
                            )
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
                                    widget.setCurrent!(GeneralMainTap.trend);
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
                        btnText: "add progress",
                        onTap: () {
                          Navigator.pushNamed(context, AppRoutes.addDailyProgressPage);
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
                          showDialog(
                            context: context,
                            builder: (context) {
                              return DeviceSetter();
                            }
                          );
                        },
                      )
                    )
                  ],
                )
              ],
            ),
          ),
        )
      ),
    );
  }
}