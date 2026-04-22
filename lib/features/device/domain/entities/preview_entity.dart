import 'dart:convert';

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

    startAt = DateTime.parse(data["startAt"]); 
    endAt = DateTime.parse(data["endAt"]); 
    goodTime = Duration(seconds: data["goodTime"]);
    badTime = Duration(seconds: data["badTime"]);
  }

  // Getters

  // text
  String get totalTimeText => (goodTime + badTime).inHours.toString();
  String get goodPerText => goodPer.toStringAsFixed(0);
  String get badPerText => goodPer.toStringAsFixed(0);

  // number
  double get goodPer => total().inMicroseconds != 0 ? (goodTime.inSeconds / total().inSeconds) * 100 : 0;
  double get badPer => total().inMicroseconds != 0 ? (badTime.inSeconds / total().inSeconds) * 100 : 0;

  Duration total() => goodTime + badTime;
}