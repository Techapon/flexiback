import 'package:flexiback/features/device/domain/entities/daily_progress_entity.dart';

class DailyProgressModel extends DailyProgressEntity {
  DailyProgressModel({
    required super.id,
    required super.img,
    required super.straightScore,
    required super.note,
    required super.dateTime
  });

  factory DailyProgressModel.fromMap(Map<String,dynamic> map) {
    return DailyProgressModel(
      id : map["id"],
      img: map["image_src"],
      straightScore: map["straight_score"],
      note: map["note"],
      dateTime: map["date_time"] != null
        ? DateTime.parse(map["date_time"]).toLocal()
        : null,
    );
  }

  factory DailyProgressModel.fromEntity(DailyProgressEntity entity) {
    return DailyProgressModel(
      id: entity.id,
      img: entity.img,
      straightScore: entity.straightScore,
      note: entity.note,
      dateTime: entity.dateTime,
    );
  }

  Map<String,dynamic> toMap(String userId) {
    return {
      "user_id" : userId,
      "image_src" : img,
      "straight_score" : super.straightScore,
      "note" : super.note,
    };
  }

  DailyProgressEntity toEntity() {
    return DailyProgressEntity(
      id: super.id,
      img: super.img,
      straightScore: super.straightScore,
      note: super.note,
      dateTime: super.dateTime,
    );
  }
  
}