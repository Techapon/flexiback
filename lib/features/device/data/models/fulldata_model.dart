import 'package:flexiback/core/enums/dot_status.dart';
import 'package:flexiback/features/device/domain/entities/preview_entity.dart';

import '../../../../core/models/dot_model.dart';
import '../../domain/entities/full_data_entity.dart';

class FulldataModel {
  final Duration goodTime;
  final Duration badTime;
  final DateTime dateTime;
  final List<DotModel> dotList;

  FulldataModel({
    required this.goodTime,
    required this.badTime,
    required this.dateTime,
    required this.dotList
  });

  factory FulldataModel.fromMap(PreviewEntity preview, Map<String, dynamic> json) {
    final List logs = json["logs"] is List ? json["logs"] : [];
    
    return FulldataModel(
      goodTime: preview.goodTime,
      badTime: preview.badTime,
      dateTime: preview.startAt.toLocal(),
      dotList: logs.map((e) {
        final dot = e as Map<String, dynamic>;
        final List angles = dot["a"] is List ? dot["a"] : [];
        
        DateTime dotTime;
        final t = dot["t"];
        if (t is num) {
          dotTime = DateTime.fromMillisecondsSinceEpoch(t.toInt());
        } else if (t is String) {
          dotTime = DateTime.tryParse(t) ?? DateTime.now();
        } else {
          dotTime = DateTime.now();
        }

        // Safety check for invalid dates from device
        if (dotTime.year < 2000) dotTime = DateTime.now();

        return DotModel(
          status: angles.any((angle) => (angle as num) > 25)
              ? DotStatus.bad
              : DotStatus.good,
          dateTime: dotTime,
        );

      }).toList(),
    );
  }


  factory FulldataModel.fromEntity(FullDataEntity entity ) {
    return FulldataModel(
      goodTime: entity.goodTime,
      badTime: entity.badTime,
      dateTime: entity.dateTime,
      dotList: entity.dotList.map(
        (d) => DotModel(status: d.status, dateTime: d.dateTime)
      ).toList()
    );
  }

  Map<String,dynamic> toMapTime({required String user_id}) {
    return {
      "user_id" : user_id,
      "good_time" : goodTime.inSeconds,
      "bad_time" : badTime.inSeconds,
      "date_time" : dateTime.toIso8601String()
    };
  }


  List<Map<String,dynamic>> toMapDots({required String user_id}) {
    List<Map<String,dynamic>> dotListMap = [];

    for (int i = 0; i < dotList.length; i++) {
      final Map<String,dynamic> dot = dotList[i].toMap(user_id: user_id);

      print(dot["date_time"]);

      dotListMap.add(dot);
    }

    return dotListMap;
  }

  FullDataEntity toEntity() {
    return FullDataEntity(
      goodTime: goodTime,
      badTime: badTime,
      dateTime: dateTime,
      dotList: dotList.map(
        (d) => d.toEntity()
      ).toList()
    );
  }
}