
import 'package:flexiback/features/profile/data/models/profile_model.dart';

import '../../domain/entities/general_entity.dart';

class GeneralModel extends GeneralEntity {
  GeneralModel({
    required super.id,
    required super.role,
    required super.img,
    required super.title,
    required super.firstName,
    required super.lastName,
    required super.gender,
    required super.age,
    required super.email,
    required super.number,
    required super.updateAt,
    required super.createdAt,

    required super.weight,
    required super.height,
    required super.pmh,
  });

  @override
  factory GeneralModel.fromMap(ProfileModel profileData, Map<dynamic, dynamic> generalData) {
    return GeneralModel(
      id: profileData.id,
      role: profileData.role,
      img: profileData.img,
      title: profileData.title,
      firstName: profileData.firstName,
      lastName: profileData.lastName,
      gender: profileData.gender,
      age: profileData.age,
      email: profileData.email,
      number: profileData.number,
      updateAt: profileData.updateAt,
      createdAt: profileData.createdAt,

      weight: generalData['weight'],
      height: generalData['height'],
      pmh: generalData['pmh'],
    );
  }

  Map<String, dynamic> toMapForGeneral() {
    return {
      'weight': weight,
      'height': height,
      'pmh': pmh,
    };
  }
}