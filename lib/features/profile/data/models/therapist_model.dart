
import 'package:flexiback/features/profile/data/models/profile_model.dart';

import '../../domain/entities/general_entity.dart';
import '../../domain/entities/therapist_entity.dart';

class TherapistModel extends TherapistEntity {
  TherapistModel({
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

    required super.specialty,
    required super.affiliation,
    required super.institution,
    required super.experience,
  });

  @override
  factory TherapistModel.fromMap(ProfileModel profileData, Map<dynamic, dynamic> therapistData) {
    return TherapistModel(
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

      specialty: therapistData["specialty"],
      affiliation: therapistData["affiliation"],
      institution: therapistData["institution"],
      experience: therapistData["experience"]
    );
  }

  factory TherapistModel.fromEntity(TherapistEntity entity) {
    return TherapistModel(
      id: entity.id,
      role: entity.role,
      img: entity.img,
      title: entity.title,
      firstName: entity.firstName,
      lastName: entity.lastName,
      gender: entity.gender,
      age: entity.age,
      email: entity.email,
      number: entity.number,
      updateAt: entity.updateAt,
      createdAt: entity.createdAt,
      specialty: entity.specialty,
      affiliation: entity.affiliation,
      institution: entity.institution,
      experience: entity.experience,
    );
  }

  Map<String, dynamic> toMapTherapist() {
    return {
      'specialty': specialty,
      'affiliation': affiliation,
      'institution': institution,
      'experience': experience,
    };
  }
}