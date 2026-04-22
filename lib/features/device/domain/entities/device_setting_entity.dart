import 'dart:convert';

import 'package:flexiback/features/device/domain/enums/device_challenges_type.dart';

class DeviceSettingEntity {
  final DeviceChallengesType challengesType;
  final Duration? duration;

  DeviceSettingEntity._({
    required this.challengesType,
    this.duration
  });

  factory DeviceSettingEntity.normal() {
    return DeviceSettingEntity._(
      challengesType: DeviceChallengesType.normal,
      duration:  DeviceChallengesType.normal.duration
    );
  }

  factory DeviceSettingEntity.custom({required Duration duration}) {
    return DeviceSettingEntity._(
      challengesType: DeviceChallengesType.custom,
      duration: duration.inSeconds < DeviceChallengesType.custom.min!.inSeconds 
                  ? DeviceChallengesType.custom.min 
                  : duration
    );
  }

  factory DeviceSettingEntity.hard() {
    return DeviceSettingEntity._(
      challengesType: DeviceChallengesType.hard,
      duration: null
    );
  }
}