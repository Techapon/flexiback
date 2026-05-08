import 'package:flexiback/core/entities/dot_entity.dart';
import 'package:intl/intl.dart';

class FullDataEntity {
  final Duration goodTime;
  final Duration badTime;
  final DateTime dateTime;
  final List<DotEntity> dotList;

  FullDataEntity({
    required this.goodTime,
    required this.badTime,
    required this.dateTime,
    required this.dotList
  });

  Duration get totalTime => Duration(seconds: goodTime.inSeconds + badTime.inSeconds);

  String get formattedDate => DateFormat('dd / MM / yy').format(dateTime);

  String _formatTime(DateTime dt) => DateFormat('HH:mm').format(dt);

  String? get startAt => dotList.isNotEmpty
    ? _formatTime(dotList.reduce((a, b) => a.dateTime.isBefore(b.dateTime) ? a : b).dateTime)
    : null;

  String? get endAt {
    if (dotList.isEmpty) return null;
    final dt = dotList.reduce((a, b) => a.dateTime.isAfter(b.dateTime) ? a : b).dateTime;
    final timeStr = _formatTime(dt);
    final isDifferentDay = dt.day != dateTime.day || dt.month != dateTime.month || dt.year != dateTime.year;
    return isDifferentDay ? "$timeStr ${DateFormat('d/MM/yyyy').format(dt)}" : timeStr;
  }

  double get goodPercentage {
    final total = totalTime.inSeconds;
    return total > 0 ? double.parse(((goodTime.inSeconds / total) * 100).toStringAsFixed(1)) : 0.0;
  }

  double get badPercentage {
    final total = totalTime.inSeconds;
    return total > 0 ? double.parse(((badTime.inSeconds / total) * 100).toStringAsFixed(1)) : 0.0;
  }

  String _formatDuration(Duration d) {
    final hours = d.inHours;
    final minutes = d.inMinutes.remainder(60);
    return "${hours.toString()}:${minutes.toString().padLeft(2, '0')}";
  }

  String get goodTimeFormatted => _formatDuration(goodTime);
  String get badTimeFormatted => _formatDuration(badTime);
  String get totalTimeFormatted => _formatDuration(totalTime);

  @override
  String toString() {
    return 'FullDataEntity(goodTime: $goodTime, badTime: $badTime, dateTime: $dateTime, dotCount: ${dotList.length})';
  }

  
}