import 'package:flexiback/core/exception/core_exception/core_error_failure.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
 
import 'auth_failure.dart';
 
class AuthErrorMapper {
  AuthErrorMapper._();
 
  static Exception fromAuthException(AuthException e) {
    final msg = e.message.toLowerCase();
 
    if (msg.contains('invalid login credentials') ||
        msg.contains('invalid email or password')) {
      return AuthFailure.invalidCredentials();
    }
 
    if (msg.contains('email not confirmed')) {
      return AuthFailure.emailNotConfirmed();
    }
 
    if (msg.contains('session_not_found') ||
        msg.contains('refresh_token_not_found') ||
        msg.contains('token is expired')) {
      return AuthFailure.sessionExpired();
    }
 
    // ── Register errors ─────────────────────────────────────────────────────
    if (msg.contains('user already registered') ||
        msg.contains('email address is already registered')) {
      return AuthFailure.emailAlreadyInUse();
    }
 
    // ── Rate limit ──────────────────────────────────────────────────────────
    if (msg.contains('rate limit') ||
        msg.contains('too many requests') ||
        e.statusCode == '429') {
      return AuthFailure.rateLimit();
    }
 
    // ── Fallback ────────────────────────────────────────────────────────────
    return CoreFailure.unknown(e.message);
  }
 
  /// แปลง error ทั่วไป (non-AuthException)
  static CoreFailure fromUnknown(Object e) {
    return CoreFailure.unknown(e.toString());
  }
}