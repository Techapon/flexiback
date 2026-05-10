import 'package:flexiback/features/device/domain/entities/daily_progress_entity.dart';

List<DailyProgressEntity> fillTheGapMonth(List<DailyProgressEntity> dailyProgressList) {
  if (dailyProgressList.isEmpty) return [];

  final startAt = dailyProgressList.first.dateTime!;
  final endAt = dailyProgressList.last.dateTime!; 

  final diffInMonths = (endAt.year *12 + endAt.month) - (startAt.year *12 + startAt.month);
  final length = diffInMonths + 1;

  final newDailyListForGraph = List.generate(length, (index) {
    final currentDate = DateTime(startAt.year, startAt.month + index, 1);

    try {
      return dailyProgressList.firstWhere((element) {
        final date = element.dateTime!;
        return date.year == currentDate.year &&
               date.month == currentDate.month;
      });
    } catch (_) {
      return DailyProgressEntity(
        id: null,
        img: null,
        straightScore: 0,
        note: null,
        dateTime: currentDate,
      );
    }
  });

  return newDailyListForGraph;
}