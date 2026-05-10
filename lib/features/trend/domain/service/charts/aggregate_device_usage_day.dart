import 'package:flexiback/features/trend/domain/entities/overview_entity.dart';

List<OverviewEntity> aggregateDeviceUsageDay(List<OverviewEntity> data) {
  if (data.isEmpty) return [];

  final Map<String, OverviewEntity> groupedData = {};

  for (final item in data) {
    if (item.dateTime == null) continue;
    final date = item.dateTime!;
    
    final key = "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
    
    if (!groupedData.containsKey(key)) {
      groupedData[key] = OverviewEntity.fromComputed(
        totalGoodTime: item.totalGoodTime ?? 0,
        totalBadTime: item.totalBadTime ?? 0,
        dateTime: DateTime(date.year, date.month, date.day),
      );
    } else {
      final existing = groupedData[key]!;
      groupedData[key] = OverviewEntity.fromComputed(
        totalGoodTime: (existing.totalGoodTime ?? 0) + (item.totalGoodTime ?? 0),
        totalBadTime: (existing.totalBadTime ?? 0) + (item.totalBadTime ?? 0),
        dateTime: DateTime(date.year, date.month, date.day),
      );
    }
  }

  final List<OverviewEntity> result = groupedData.values.toList();
  result.sort((a, b) => a.dateTime!.compareTo(b.dateTime!));

  return result;
}
