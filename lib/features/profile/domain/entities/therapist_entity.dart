import 'package:flexiback/features/profile/domain/entities/profile_entity.dart';

class TherapistEntity extends ProfileEntity {
  String? specialty; 
  String? affiliation; 
  String? institution;
  String? experience; 

  TherapistEntity({
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

    required this.specialty,
    required this.affiliation,
    required this.institution,
    required this.experience,
  });

  @override
  TherapistEntity get getProfileData => TherapistEntity(
    id: id,
    role: role,
    img: img,
    title: title,
    firstName: firstName,
    lastName: lastName,
    gender: gender,
    age: age,
    email: email,
    number: number,
    updateAt: updateAt,
    createdAt: createdAt,

    specialty: specialty,
    affiliation: affiliation,
    institution: institution,
    experience: experience
  );

  @override
  String toString() {
    return 'THEARPIST -- ProfileEntity(id: $id, role: $role, title: $title, firstName: $firstName, lastName: $lastName, gender: $gender, age: $age, email: $email, number: $number, updateAt: $updateAt, createdAt: $createdAt)';
  }
}