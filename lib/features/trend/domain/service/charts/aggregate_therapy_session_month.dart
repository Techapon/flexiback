import '../../entities/therapy_session_trend_entity.dart';

List<(DateTime, double)> aggregateTherapySessionMonth(List<TherapySessionTrendEntity> data) {
  if (data.isEmpty) return [];

  final Map<String, List<TherapySessionTrendEntity>> groupedData = {};

  for (final item in data) {
    final date = item.dateTime;
    final key = "${date.year}-${date.month.toString().padLeft(2, '0')}";
    
    if (!groupedData.containsKey(key)) {
      groupedData[key] = [];
    }
    groupedData[key]!.add(item);
  }

  final List<(DateTime, double)> result = [];

  for (final entry in groupedData.entries) {
    final list = entry.value;
    double totalScore = 0;
    
    for (final item in list) {
      totalScore += item.score;
    }
    
    final firstItemDate = list.first.dateTime;
    final representativeDate = DateTime(firstItemDate.year, firstItemDate.month, 1);

    result.add((representativeDate, totalScore));
  }
  result.sort((a, b) => a.$1.compareTo(b.$1));

  return result;
}
