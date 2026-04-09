import 'auth_error_type.dart';

class AuthFailure implements Exception {
  final AuthErrorType type;
  final String message;

  const AuthFailure({
    required this.type,
    required this.message,
    this.debugMessage,
  });

  final String? debugMessage;

  factory AuthFailure.invalidCredentials() => const AuthFailure(
        type: AuthErrorType.invalidCredentials,
        message: 'Email or Password is not correct.',
      );

  factory AuthFailure.rateLimit() => const AuthFailure(
        type: AuthErrorType.rateLimit,
        message: 'You have made too many requests. Please try again later.',
      );

  factory AuthFailure.emailNotConfirmed() => const AuthFailure(
        type: AuthErrorType.emailNotConfirmed,
        message: 'Please confirm your email before logging in.',
      );

  factory AuthFailure.emailAlreadyInUse() => const AuthFailure(
        type: AuthErrorType.emailAlreadyInUse,
        message: 'Email is already in use.',
      );

  factory AuthFailure.sessionExpired() => const AuthFailure(
        type: AuthErrorType.sessionExpired,
        message: 'Session expired. Please log in again.',
      );

  @override
  String toString() => message;
}