import '../../../../core/models/dot_model.dart';
import '../../domain/entities/full_data_entity.dart';

class FulldataModel {
  final Duration goodTime;
  final Duration badTime;
  final List<DotModel> dotList;

  FulldataModel({
    required this.goodTime,
    required this.badTime,
    required this.dotList
  });

  factory FulldataModel.fromMap(Map<String,dynamic> json) {
    return FulldataModel(
      goodTime: json["goodTime"],
      badTime: json["badTime"],
      dotList: json["dotList"]
    );
  }

  factory FulldataModel.fromEntity(FullDataEntity entity ) {
    return FulldataModel(
      goodTime: entity.goodTime,
      badTime: entity.badTime,
      dotList: entity.dotList.map(
        (d) => DotModel(value: d.value, dateTime: d.dateTime)
      ).toList()
    );
  }

  Map<String,dynamic> toMapTime({required String user_id}) {
    return {
      "user_id" : user_id,
      "good_time" : goodTime,
      "bad_time" : badTime
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
      dotList: dotList.map(
        (d) => d.toEntity()
      ).toList()
    );
  }
}