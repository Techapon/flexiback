import 'dart:convert';
import 'package:intl/intl.dart';

class PreviewEntity {
  final String jsonString;
  late final Map<String,dynamic> data;
  late final DateTime startAt;
  late final DateTime endAt;
  late final Duration goodTime;
  late final Duration badTime;

  PreviewEntity({
    required this.jsonString
  }) {
    data = jsonDecode(jsonString);

    startAt = _parseDate(data["start_at"]); 
    endAt = _parseDate(data["end_at"]); 
    goodTime = Duration(seconds: data["summary"]["good"]);
    badTime = Duration(seconds: data["summary"]["bad"]);
  }

  DateTime _parseDate(dynamic value) {
    if (value == null || value == "N/A" || value == "") return DateTime.now();
    try {
      return DateTime.parse(value.toString());
    } catch (_) {
      return DateTime.now();
    }
  }


  // Getters

  // text
  String get totalTimeText => (goodTime + badTime).inHours.toString();
  String get goodPerText => goodPer.toStringAsFixed(0);
  String get badPerText => badPer.toStringAsFixed(0);
  
  String get goodTimeText => "${goodTime.inHours}:${(goodTime.inMinutes % 60).toString().padLeft(2, '0')}";
  String get badTimeText => "${badTime.inHours}:${(badTime.inMinutes % 60).toString().padLeft(2, '0')}";


  String get totalHour => total().inHours.toString();
  String get totalminute => (total().inMinutes % 60).toString();

  String get getDateTime {
    final timeFormat = DateFormat('h:mm a');
    final dateFormat = DateFormat('d/M/y');
    return "Date from ${timeFormat.format(startAt).toLowerCase()} to ${timeFormat.format(endAt).toLowerCase()} on ${dateFormat.format(endAt)}.";
  }


  // number
  double get goodPer => total().inMicroseconds != 0 ? (goodTime.inSeconds / total().inSeconds) * 100 : 0;
  double get badPer => total().inMicroseconds != 0 ? (badTime.inSeconds / total().inSeconds) * 100 : 0;

  

  Duration total() => goodTime + badTime;

  @override
  String toString() {
    return 'PreviewEntity(startAt: $startAt, endAt: $endAt, goodTime: $goodTime, badTime: $badTime)';
  }
}