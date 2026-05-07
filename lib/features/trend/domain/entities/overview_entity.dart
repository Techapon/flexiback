class OverviewEntity {
  final double? totalGoodTime;
  final double? totalBadTime;
  final double? goodPercentage;
  final double? badPercentage;
  final DateTime? dateTime;

  OverviewEntity({
    this.totalGoodTime,
    this.totalBadTime,
    this.goodPercentage,
    this.badPercentage,
    this.dateTime
  });

  factory OverviewEntity.fromComputed({
    required double totalGoodTime,
    required double totalBadTime,
  }) {
    final total = totalGoodTime + totalBadTime;
    final goodPercentage = total > 0 ? ((totalGoodTime / total) * 100).toDouble() : 0.0;
    final badPercentage = total > 0 ? ((totalBadTime / total) * 100).toDouble() : 0.0;

    return OverviewEntity(
      totalGoodTime: totalGoodTime,
      totalBadTime: totalBadTime,
      goodPercentage: goodPercentage,
      badPercentage: badPercentage,
    );
  }

  int get totalHours {
    final totalSeconds = ((totalGoodTime ?? 0) + (totalBadTime ?? 0)).toInt();
    return totalSeconds ~/ 3600;
  }

  int get totalMinutes {
    final totalSeconds = ((totalGoodTime ?? 0) + (totalBadTime ?? 0)).toInt();
    return (totalSeconds % 3600) ~/ 60;
  }

  String get totalTimeFormatted {
    return "${totalHours.toString().padLeft(2, '0')}:${totalMinutes.toString().padLeft(2, '0')}";
  }

  @override
  String toString() {
    return "G : $totalGoodTime , $goodPercentage% |\n B : $totalBadTime , $badPercentage% | ";
  }
}
