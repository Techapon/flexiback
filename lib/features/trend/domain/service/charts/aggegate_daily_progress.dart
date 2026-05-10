import 'package:flexiback/features/device/domain/entities/daily_progress_entity.dart';
import 'package:flexiback/features/trend/domain/service/charts/divide_month.dart';

List<DailyProgressEntity> aggegateDailyProgressMonth(List<DailyProgressEntity> data) {
  if (data.isEmpty) return [];

  final groupedData = divideMonth(data);

  final List<DailyProgressEntity> result = [];

  for (final entry in groupedData.entries) {
    final list = entry.value;
    double totalScore = 0;
    
    for (final item in list) {
      totalScore += (item.straightScore ?? 0);
    }

    final averageScore = totalScore / list.length;
    
    final firstItemDate = list.first.dateTime!;
    final representativeDate = DateTime(firstItemDate.year, firstItemDate.month, 1);

    result.add(DailyProgressEntity(
      id: null,
      img: null,
      straightScore: averageScore,
      note: null,
      dateTime: representativeDate,
    ));
  }
  result.sort((a, b) => a.dateTime!.compareTo(b.dateTime!));

  return result;
}