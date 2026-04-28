import '../enums/role.dart';

Role getRole(String role) {
  final r = role.toLowerCase();

  if (r == Role.General.entity) {
    return Role.General;
  } else if (r == Role.Therapist.entity) {
    return Role.Therapist;
  }

  return Role.General;
}

Role getOppositeRole(String role) {
  final r = role.toLowerCase();

  if (r == Role.General.entity) {
    return Role.Therapist;
  } else if (r == Role.Therapist.entity) {
    return Role.General;
  }

  return Role.General;
}