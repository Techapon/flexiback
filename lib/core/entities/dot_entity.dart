import 'package:flexiback/core/enums/dot_status.dart';

class DotEntity {
  final DotStatus status;
  final DateTime dateTime;

  DotEntity({
    required this.status,
    required this.dateTime
  });

  @override
  String toString() => '${dateTime.toIso8601String()} : ${status.entity}';
}