
import '../../domain/entities/profile_entity.dart';

class ProfileModel extends ProfileEntity {
  ProfileModel({
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
  });

  factory ProfileModel.fromMap(Map<String, dynamic> map, String email, DateTime createdAt) {
    return ProfileModel(
      id: map['id'],
      role: map['role'],
      img: map['img'],
      title: map['title'],
      firstName: map['first_name'],
      lastName: map['last_name'],
      gender: map['gender'],
      age: map['age'],
      email: email,
      number: map['number'],
      updateAt: map['updated_at'],
      createdAt: createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'role': role,
      'img': img,
      'title': title,
      'first_name': firstName,
      'last_name': lastName,
      'gender': gender,
      'age': age,
      'email': email,
      'number': number,
      'updated_at': updateAt,
      'created_at': createdAt,
    };
  }
}