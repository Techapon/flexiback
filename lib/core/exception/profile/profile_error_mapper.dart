import 'package:flexiback/core/exception/core_exception/core_error_failure.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
 
import 'profile_failure.dart';
 
class ProfileErrorMapper {
  ProfileErrorMapper._();
 
  static Exception fromAuthException(AuthException e) {
    final msg = e.message.toLowerCase();
 
    if (msg.contains('session_not_found') ||
        msg.contains('refresh_token_not_found') ||
        msg.contains('token is expired')) {
      return ProfileFailure.sessionExpired();
    }
   
    // ── Fallback ────────────────────────────────────────────────────────────
    return CoreFailure.unknown(e.message);
  }

  static CoreFailure fromUnknown(Object e) {
    return CoreFailure.unknown(e.toString());
  }

}