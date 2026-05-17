import 'package:flexiback/features/therapy/domain/entities/therapy_session.dart';

abstract class TherapyRepository {
  Future uploadTherapySession(TherapySession session);
}