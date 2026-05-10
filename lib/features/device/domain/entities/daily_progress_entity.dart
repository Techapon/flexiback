import 'package:flexiback/core/entities/image_entity.dart';
import 'package:intl/intl.dart';

class DailyProgressEntity {
  final String? id;
  String? img;
  double? straightScore;
  String? note;
  final DateTime? dateTime;

  DailyProgressEntity({
    this.id,
    required this.img,
    required this.straightScore,
    this.note,
    this.dateTime
  });

  // Getter
  String? get formattedDate => (dateTime != null) ? DateFormat("dd / MM / yy").format(dateTime!) : null;
  String? get getNote => note == null || note == "" ? null : note;

  @override
  String toString() => "score : $straightScore, date : $dateTime";
}