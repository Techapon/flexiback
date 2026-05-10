import 'package:flexiback/features/trend/domain/entities/overview_entity.dart';

List<OverviewEntity> fillTheGapDeviceUsageDay(List<OverviewEntity> data) {
  if (data.isEmpty) return [];

  final startAt = data.first.dateTime!;
  final endAt = data.last.dateTime!; 

  final diffInDays = endAt.difference(startAt).inDays;
  final length = diffInDays + 1;

  final newDataList = List.generate(length, (index) {
    final currentDate = startAt.add(Duration(days: index));

    try {
      return data.firstWhere((element) {
        final date = element.dateTime!;
        return date.year == currentDate.year &&
               date.month == currentDate.month &&
               date.day == currentDate.day;
      });
    } catch (_) {
      return OverviewEntity.fromComputed(
        totalGoodTime: 0,
        totalBadTime: 0,
        dateTime: currentDate,
      );
    }
  });

  return newDataList;
}
