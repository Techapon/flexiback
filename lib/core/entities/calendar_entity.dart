class CalendarEntity {
  final List<DateTime?> usageDates;
  final DateTime first;
  final DateTime focus;
  final DateTime last;

  CalendarEntity({
    required this.usageDates,
    required this.first,
    required this.focus,
    required this.last,
  });

  factory CalendarEntity.fromUsageDates(List<DateTime?> usageDates) {
    late DateTime first;
    late DateTime focus;
    late DateTime last;

    if (usageDates.isNotEmpty) {
      final sortedDates = List<DateTime?>.from(usageDates)..sort((a, b) => a!.compareTo(b!));
      first = sortedDates.first!;
      focus = sortedDates.last!;
      last = sortedDates.last!;
    } else {
      final now = DateTime.now();
      first = DateTime(now.year, now.month, 1);
      focus = DateTime(now.year, now.month, 1);
      last = DateTime(now.year, now.month, 30);
    }

    return CalendarEntity(
      usageDates: usageDates,
      first: first,
      focus: focus,
      last: last,
    );
  }

  @override
  String toString() => 'CalendarEntity(first: $first, focus: $focus, last: $last, dates: ${usageDates.length})';
}
