import 'package:flexiback/config/theme/colors/app_color.dart';
import 'package:flexiback/core/constants/flexiback.dart';
import 'package:flexiback/features/device/domain/entities/device_setting_entity.dart';
import 'package:flexiback/features/device/domain/enums/device_challenges_type.dart';
import 'package:flexiback/features/device/presentation/controller/device_provider.dart';
import 'package:flexiback/shared/widgets/general/gradient_button.dart';
import 'package:flexiback/shared/widgets/dialog/error/dialog_error.dart';
import 'package:flexiback/shared/widgets/form/dropdown.dart';
import 'package:flexiback/shared/widgets/form/pill_field.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';

class DeviceSetter extends StatefulWidget {
  const DeviceSetter({super.key});

  @override
  State<DeviceSetter> createState() => _DeviceSetterState();
}

class _DeviceSetterState extends State<DeviceSetter> {
  final TextEditingController _typeController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();

  final List<String> challengeList = [
    DeviceChallengesType.normal.entity,
    DeviceChallengesType.custom.entity,
    DeviceChallengesType.hard.entity,
  ];
  late ValueNotifier<String?> valueListenable_challengeType;

  @override
  void initState() {
    valueListenable_challengeType = ValueNotifier(null);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final deviceProvider = context.read<DeviceProvider>();

      final DeviceSettingEntity? deviceSetting = deviceProvider!.deviceSetting;

      valueListenable_challengeType.value = 
        deviceSetting?.challengesType.entity ?? challengeList[0];

        // Controller
      _typeController.value = TextEditingValue(
        text: deviceSetting?.challengesType.entity ?? challengeList[0]
      );
      _durationController.value = TextEditingValue(
        text: deviceSetting?.duration?.inSeconds.toString() ?? DeviceChallengesType.custom.min!.inSeconds.toString()
      );

      setState(() {});
    });
  }

  // state valible halper
  bool successed = false;
  
  @override
  void dispose() {
    valueListenable_challengeType.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final deviceProvider = context.watch<DeviceProvider>(); 

    return PopScope(
      canPop: !deviceProvider.isLoading,
      child: Dialog(
        insetPadding: EdgeInsets.symmetric(horizontal: 20),
        backgroundColor: AppColor.base1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28)
        ),
        child: IntrinsicWidth(
          child: Container(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              spacing: 16,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Device Setting",
                  style: TextStyle(
                    color: AppColor.black1,
                    fontSize: 24,
                    fontWeight: FontWeight.bold
                  ),
                ),
                    
                Column(
                  spacing: 8,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Challenge type",
                      style: TextStyle(
                        color: AppColor.grey4,
                        fontSize: 14
                      ),
                    ),
                    
                    Custom_Dropdown(
                      valueListenable_title: valueListenable_challengeType,
                      List_items: challengeList,
                      onChanged: (value) {
                        _typeController.value = TextEditingValue(
                          text: value
                        );
      
                        setState(() {});
                      }
                    )
                  ],
                ),
                    
                Column(
                  spacing: 8,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Duration (${ 
                        _typeController.text == DeviceChallengesType.normal.entity
                        ? 'can not custom in normal mode'
                        : _typeController.text == DeviceChallengesType.custom.entity
                          ? 'min is ${DeviceChallengesType.custom.min!.inSeconds}, max is ${DeviceChallengesType.custom.max!.inSeconds} seconds'
                          : _typeController.text == DeviceChallengesType.hard.entity
                            ? 'can not custom in hard mode' : ''
                      })",
                      style: TextStyle(
                        color: AppColor.grey4,
                        fontSize: 14
                      ),
                    ),
                        
                    PillField(
                      key: ValueKey(_typeController.text),
                      keyboardType: TextInputType.number,
                      title: 'duration',
                      value:  _typeController.text == DeviceChallengesType.normal.entity
                        ? DeviceChallengesType.normal.duration!.inSeconds
                        : _typeController.text == DeviceChallengesType.custom.entity
                          ?  int.tryParse(_durationController.text)
                          : _typeController.text == DeviceChallengesType.hard.entity
                            ? null : null,
                      blank: _typeController.text == DeviceChallengesType.hard.entity 
                        ? "will not notify"
                        : null,
                      unit: 'seconds',
                      enable: (
                        _typeController.text == DeviceChallengesType.normal.entity 
                        || _typeController.text == DeviceChallengesType.hard.entity
                      ) ? false : true,
                      maxValueInt: DeviceChallengesType.custom.max!.inSeconds,
                      minValueInt: DeviceChallengesType.custom.min!.inSeconds,
                      onChanged: (value) {
                        _durationController.value =  TextEditingValue(
                          text:  value.toString()
                        );
                      },
                    )
                  ],
                ),
      
                SizedBox(height: 8),
      
                GradientButton(
                  onTap: () async {
                    if (!deviceProvider.isConnected) return;
                    final type = DeviceChallengesType.fromEntity(_typeController.text);
                    
                    late DeviceSettingEntity setting;
      
                    switch (type) {
                      case DeviceChallengesType.normal:
                        setting = DeviceSettingEntity.normal();
                        break;
                      case DeviceChallengesType.custom:
                        final durationSeconds = int.tryParse(_durationController.text) ?? 
                                               DeviceChallengesType.custom.min!.inSeconds;
                        setting = DeviceSettingEntity.custom(duration: Duration(seconds: durationSeconds));
                        break;
                      case DeviceChallengesType.hard:
                        setting = DeviceSettingEntity.hard();
                        break;
                    }
    
                    await deviceProvider.updateDeviceSetting(setting);
      
                    if (deviceProvider.error != null) {
                      showErrorDialog(
                        context: context,
                        message: deviceProvider.error!
                      );
                    } else {
                      setState(() {
                        successed = true;
                      });
                      Future.delayed(Duration(seconds: 3));

                      setState(() {
                        successed = false;
                      });
                    }
                  },
                  disable: !deviceProvider.isConnected,
                  child: Row(
                    spacing: 8,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (deviceProvider.isLoading)
                        SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.5,
                          ),
                        ), 
                      if (successed)
                        Icon(
                          LucideIcons.check500,
                          size: 18,
                          color: AppColor.success,
                        ),
                      Text(
                        successed
                          ? "Upload and save success!"
                          : deviceProvider.isConnected
                            ? deviceProvider.isLoading
                              ? "Uploading..."
                              : "upload and save change"
                            : "Please connect to device"
                        ,
                        style: TextStyle(
                          color: AppColor.base1,
                          fontSize: 16,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ],
                  )
                )
              ],
            )
          ),
        ),
      ),
    );
  }
}