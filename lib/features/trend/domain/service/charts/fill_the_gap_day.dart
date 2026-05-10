import 'package:flexiback/features/device/domain/entities/daily_progress_entity.dart';

List<DailyProgressEntity> fillTheGapDay(List<DailyProgressEntity> dailyProgressList) {
  if (dailyProgressList.isEmpty) return [];

  final startAt = dailyProgressList.first.dateTime!;
  final endAt = dailyProgressList.last.dateTime!; 

  final diffInDays = endAt.difference(startAt).inDays;
  final length = diffInDays + 1;

  final newDailyListForGraph = List.generate(length, (index) {
    final currentDate = startAt.add(Duration(days: index));

    try {
      return dailyProgressList.firstWhere((element) {
        final date = element.dateTime!;
        return date.year == currentDate.year &&
               date.month == currentDate.month &&
               date.day == currentDate.day;
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