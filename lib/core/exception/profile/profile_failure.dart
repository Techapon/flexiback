import 'profile_error_type.dart';

class ProfileFailure implements Exception {
  final ProfileErrorType type;
  final String message;

  const ProfileFailure({
    required this.type,
    required this.message,
  });

  factory ProfileFailure.sessionExpired() => const ProfileFailure(
        type: ProfileErrorType.sessionExpired,
        message: 'เซสชันหมดอายุ กรุณาเข้าสู่ระบบใหม่',
      );
      
  @override
  String toString() => message;
}