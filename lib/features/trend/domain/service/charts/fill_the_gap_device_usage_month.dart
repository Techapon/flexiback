import 'package:flexiback/features/trend/domain/entities/overview_entity.dart';

List<OverviewEntity> fillTheGapDeviceUsageMonth(List<OverviewEntity> data) {
  if (data.isEmpty) return [];

  final startAt = data.first.dateTime!;
  final endAt = data.last.dateTime!;

  final int monthsDiff = (endAt.year - startAt.year) * 12 + endAt.month - startAt.month;
  final length = monthsDiff + 1;

  final newDataList = List.generate(length, (index) {
    int targetMonth = startAt.month + index;
    int targetYear = startAt.year + (targetMonth - 1) ~/ 12;
    targetMonth = (targetMonth - 1) % 12 + 1;

    try {
      return data.firstWhere((element) {
        final date = element.dateTime!;
        return date.year == targetYear && date.month == targetMonth;
      });
    } catch (_) {
      return OverviewEntity.fromComputed(
        totalGoodTime: 0,
        totalBadTime: 0,
        dateTime: DateTime(targetYear, targetMonth, 1),
      );
    }
  });

  return newDataList;
}
