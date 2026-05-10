enum ChartPeriod {
  day(
    entity: "Day"
  ),
  month(
    entity: "Month"
  );

  final String entity;
  const ChartPeriod({
    required this.entity
  });

  static ChartPeriod fromEntity(String entity) {
    return values.firstWhere(
      (period) => period.entity == entity,
      orElse: () => ChartPeriod.day
    );
  }
}
