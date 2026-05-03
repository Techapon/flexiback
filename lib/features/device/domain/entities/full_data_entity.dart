import 'package:flexiback/core/entities/dot_entity.dart';

class FullDataEntity {
  final Duration goodTime;
  final Duration badTime;
  final DateTime dateTime;
  final List<DotEntity> dotList;

  FullDataEntity({
    required this.goodTime,
    required this.badTime,
    required this.dateTime,
    required this.dotList
  });

  Duration get totalTime => Duration(seconds:goodTime.inSeconds + badTime.inSeconds);

  @override
  String toString() {
    return 'FullDataEntity(goodTime: $goodTime, badTime: $badTime, dateTime: $dateTime, dotCount: ${dotList.length})';
  }
}