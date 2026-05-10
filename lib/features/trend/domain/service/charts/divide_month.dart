
import 'package:flexiback/features/device/domain/entities/daily_progress_entity.dart';

Map<String, List<DailyProgressEntity>> divideMonth(List<DailyProgressEntity> data) {
  final Map<String, List<DailyProgressEntity>> groupedData = {};

  for (final item in data) {
    if (item.dateTime == null) continue;
    final date = item.dateTime!;
    
    final key = "${date.year}-${date.month.toString().padLeft(2, '0')}";
    
    if (!groupedData.containsKey(key)) {
      groupedData[key] = [];
    }
    groupedData[key]!.add(item);
  }

  return groupedData;
}