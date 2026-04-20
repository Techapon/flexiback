import 'dart:convert';

class FullDataEntity {
  final String jsonString;
  late final Map<String,dynamic> data;

  FullDataEntity({
    required this.jsonString
  }) {
    data = jsonDecode(jsonString);
  }

}