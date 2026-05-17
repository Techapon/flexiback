import 'package:flexiback/features/therapy/data/datasources/therapy_datasource.dart';
import 'package:flexiback/features/therapy/domain/entities/therapy_session.dart';
import 'package:flexiback/features/therapy/domain/repositories/therapy_repository.dart';

class TherapyRepositoryImpl implements TherapyRepository {
  final TherapyDatasource datasource;

  TherapyRepositoryImpl(this.datasource);

  @override
  Future uploadTherapySession(TherapySession session) {
    return datasource.uploadTherapySession(session);
  }

}