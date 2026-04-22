import 'package:flexiback/core/entities/dot_entity.dart';

class DotModel extends DotEntity {
  DotModel({
    required super.value,
    required super.dateTime,
  });

  DotEntity toEntity() {
    return DotEntity(
      value: super.value,
      dateTime: super.dateTime
    );
  }

  Map<String,dynamic> toMap({String? user_id}) {
    return {
      if (user_id != null ) "user_id" : user_id,
      "value" : super.value,
      "date_time": super.dateTime
    };
  }
}