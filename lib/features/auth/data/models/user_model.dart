import 'package:flexiback/features/auth/domain/entities/user_entity.dart';

class UserModel extends UserEntity{
  UserModel({
    required super.id,
    required super.email,
    required super.role
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      email: map['email'],
      role: map['role']
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
    };
  }
}