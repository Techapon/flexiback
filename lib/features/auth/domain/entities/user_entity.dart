import '../../../../shared/entities/role_enum.dart';

class UserEntity {
  final String id;
  final String email;
  final Role role;

  UserEntity({
    required this.id,
    required this.email,
    required this.role
  });
}