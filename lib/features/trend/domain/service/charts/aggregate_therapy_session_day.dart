import '../../entities/therapy_session_trend_entity.dart';

List<(DateTime, double)> aggregateTherapySessionDay(List<TherapySessionTrendEntity> items) {
  final Map<String, double> aggregatedData = {};

  for (var item in items) {
    final dateKey = "${item.dateTime.year}-${item.dateTime.month.toString().padLeft(2, '0')}-${item.dateTime.day.toString().padLeft(2, '0')}";

    if (aggregatedData.containsKey(dateKey)) {
      aggregatedData[dateKey] = aggregatedData[dateKey]! + item.score;
    } else {
      aggregatedData[dateKey] = item.score;
    }
  }

  final List<(DateTime, double)> result = aggregatedData.entries.map((entry) {
    final dateParts = entry.key.split('-');
    final dateTime = DateTime(
      int.parse(dateParts[0]),
      int.parse(dateParts[1]),
      int.parse(dateParts[2]),
    );
    return (dateTime, entry.value);
  }).toList();

  result.sort((a, b) => a.$1.compareTo(b.$1));

  return result;
}
