import 'dart:convert';

import '../../domain/entities/classes/device_setting_entity.dart';
import '../../domain/entities/enums/device_challenges_type.dart';

class DeviceSettingModel {
  final DeviceChallengesType challengesType;
  final int? duration;

  DeviceSettingModel({
    required this.challengesType,
    this.duration
  });

  // Map concvertor
  factory DeviceSettingModel.formMap(Map<String,dynamic> map) {
    return DeviceSettingModel(
      challengesType: map["type"],
      duration: map["duration"]
    );
  }

  Map<String,dynamic> toMap() {
    return {
      "type" : challengesType.entity,
      "duration" : duration
    };
  }

  // Entity convertor
  factory DeviceSettingModel.fromEntity(DeviceSettingEntity entity) {
    return DeviceSettingModel(
      challengesType: entity.challengesType,
      duration: entity.duration?.inSeconds
    );
  }

  DeviceSettingEntity toEntity() {
    switch (challengesType) {
      case DeviceChallengesType.normal:
        return DeviceSettingEntity.normal();

      case DeviceChallengesType.custom:
        return DeviceSettingEntity.custom(duration: Duration(seconds: duration ?? 0));

      case DeviceChallengesType.hard:
        return DeviceSettingEntity.hard();
    }
  }

  // Json String
  
  String toJsonString() {
    String jsonString;

    if (challengesType == DeviceChallengesType.hard) {
      jsonString = jsonEncode({
        "type" : challengesType.entity,
      });

      return jsonString;
    } else {
      jsonString = jsonEncode(toMap());
      return jsonString;
    }
  }

}