import 'dart:convert';

double? SCCalculation(Map<String,dynamic>? data) {
  if (data == null) return null;
  
  double totalAngles = 0;
  int sensorCount = 0;

  final String strignData = jsonEncode(data);

  for (int i = 2; i<= 7; i++) {
    if (strignData.contains("C$i")) {
      sensorCount++;
      totalAngles = (data["C$i"] as double).abs();
    }
  }

  final double score  = 100 - (totalAngles / (sensorCount*180));
  return score;
}