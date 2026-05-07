import 'package:flexiback/features/trend/domain/entities/overview_entity.dart';

class OverviewModel {
  final DateTime? dateTime;
  final double? goodTime;
  final double? badTime;

  OverviewModel({
    this.dateTime,
    this.goodTime,
    this.badTime,
  });

  factory OverviewModel.fromMap(Map<String, dynamic> map) {
    return OverviewModel(
      dateTime: map["date_time"] != null
        ? DateTime.parse(map["date_time"]).toLocal()
        : null,
      goodTime: map["good_time"] != null ? (map["good_time"] as num).toDouble() : null,
      badTime: map["bad_time"] != null ? (map["bad_time"] as num).toDouble() : null,
    );
  }

  OverviewEntity toEntity() {
    return OverviewEntity(
      totalGoodTime: goodTime,
      totalBadTime: badTime,
      goodPercentage: null,
      badPercentage: null,
      dateTime: dateTime
    );
  }

}
