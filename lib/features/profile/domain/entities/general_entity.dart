
import 'package:flexiback/features/profile/domain/entities/profile_entity.dart';

class GeneralEntity extends ProfileEntity {
  double? weight;
  double? height;
  String? pmh;

  GeneralEntity({
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

    required this.weight,
    required this.height,
    required this.pmh,
  });

  @override
  GeneralEntity get getProfileData => GeneralEntity(
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

    weight: weight,
    height: height,
    pmh: pmh,
  );

  @override
  String toString() {
    return 'GENERAL -- ProfileEntity(id: $id, role: $role, title: $title, firstName: $firstName, lastName: $lastName, gender: $gender, age: $age, email: $email, number: $number, updateAt: $updateAt, createdAt: $createdAt)';
  }
}