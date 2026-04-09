import 'package:flexiback/core/exception/core_exception/core_error_failure.dart';

class CoreErrorMapper {
  CoreErrorMapper._();
 
  static Exception fromCoreException(CoreFailure e) {
    final msg = e.message.toLowerCase();
   
    // ── Fallback ────────────────────────────────────────────────────────────
    return CoreFailure.unknown(e.message);
  }
 
  /// แปลง error ทั่วไป (non-AuthException)
  static CoreFailure fromUnknown(Object e) {
    return CoreFailure.unknown(e.toString());
  }
}