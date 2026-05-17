import '../../domain/entities/therapy_session_trend_entity.dart';

class TherapySessionTrendModel {
  final int score;
  final DateTime createdAt;

  TherapySessionTrendModel({
    required this.score,
    required this.createdAt,
  });

  factory TherapySessionTrendModel.fromMap(Map<String, dynamic> map) {
    return TherapySessionTrendModel(
      score: map['score']?.toInt() ?? 0,
      createdAt: DateTime.parse(map['created_at']).toLocal(),
    );
  }

  TherapySessionTrendEntity toEntity() {
    return TherapySessionTrendEntity(
      score: score.toDouble(),
      dateTime: createdAt,
    );
  }
}
