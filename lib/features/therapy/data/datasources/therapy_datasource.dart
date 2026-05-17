import 'package:flexiback/core/exception/core_exception/core_error_failure.dart';
import 'package:flexiback/features/therapy/domain/entities/therapy_session.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TherapyDatasource {
  final supabase = Supabase.instance.client;

  Future<void> uploadTherapySession(TherapySession session) async {
    try {
      final currentUser = supabase.auth.currentUser;
      final userId = currentUser?.id;

      if (userId == null) throw CoreFailure.unknown("User not authenticated");

      final sessionJson = {
        "user_id" : userId,
        "score" : session.totalReps,
      };
      
      await supabase.from("therapy_sessions").insert(sessionJson);

    } on PostgrestException catch (e) {
      print("Postgest : ${e.toString()}");
      throw CoreFailure.databaseError(e.message);
    } catch (e) {
      print("Dont Know : ${e.toString()}");
      throw CoreFailure.unknown(e.toString());
    }
  }
}