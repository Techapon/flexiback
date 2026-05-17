import '../entities/therapy_session_trend_entity.dart';
import '../repositories/trend_repository.dart';

class GetTherapySessionsUsecase {
  final TrendRepository repository;

  GetTherapySessionsUsecase(this.repository);

  Future<List<TherapySessionTrendEntity>> call(String userId) async {
    return await repository.getTherapySessions(userId);
  }
}
