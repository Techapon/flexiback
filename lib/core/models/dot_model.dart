import 'package:flexiback/core/entities/dot_entity.dart';
import 'package:flexiback/core/enums/dot_status.dart';

class DotModel {
  final DotStatus status;
  final DateTime dateTime;

  DotModel({
    required this.status,
    required this.dateTime
  });

  DotEntity toEntity() {
    return DotEntity(
      status: status,
      dateTime: dateTime
    );
  }

  Map<String,dynamic> toMap({String? user_id}) {
    final safeDateTime = (dateTime.year < 2000) ? DateTime.now() : dateTime;
    return {
      if (user_id != null ) "user_id" : user_id,
      "status" : status.entity,
      "date_time": safeDateTime.toIso8601String()
    };

  }

  
}