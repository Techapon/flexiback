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

  factory FulldataModel.fromMap(PreviewEntity preview,Map<String,dynamic> json) {
    final jsonFullData = json["logs"] as List<Map<String,dynamic>>;
    return FulldataModel(
      goodTime: preview.goodTime,
      badTime: preview.badTime,
      dateTime: preview.startAt.toLocal(),
      dotList: (jsonFullData).map(
        (dot) => DotModel(
          status: (dot["a"] as List<double>).any((angle) => angle > 25)
            ?  DotStatus.bad
            : DotStatus.good,
          dateTime: dot["t"]
        )
      ).toList()
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
      "good_time" : goodTime,
      "bad_time" : badTime,
      "date_time" : dateTime
    };
  }

  List<Map<String,dynamic>> toMapDots({required String user_id}) {
    List<Map<String,dynamic>> dotListMap = [];

    for (int i = 0; i < dotList.length; i++) {
      final Map<String,dynamic> dot = dotList[i].toMap(user_id: user_id);

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