import 'package:flexiback/core/entities/dot_entity.dart';

class FullDataEntity {
  final Duration goodTime;
  final Duration badTime;
  final List<DotEntity> dotList;

  FullDataEntity({
    required this.goodTime,
    required this.badTime,
    required this.dotList
  });

  Duration get totalTime => Duration(seconds:goodTime.inSeconds + badTime.inSeconds);

}