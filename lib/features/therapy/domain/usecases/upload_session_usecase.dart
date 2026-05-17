import 'package:flexiback/features/therapy/domain/entities/therapy_session.dart';
import 'package:flexiback/features/therapy/domain/repositories/therapy_repository.dart';

class UploadSessionUsecase {
  TherapyRepository repo;

  UploadSessionUsecase(this.repo);

  Future call(TherapySession session) {
    return repo.uploadTherapySession(session);
  }
}