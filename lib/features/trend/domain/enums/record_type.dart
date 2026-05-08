import 'package:flexiback/features/trend/presentation/widgets/graph/on_off/on_of_graph.dart';

enum RecordType {
  deviceUsage(
    entity: "Device Usage"
  ),
  dailyProgress(
    entity: "Daily Progress"
  );

  final String entity;
  const RecordType({
    required this.entity
  });

  static RecordType fromEntity(String entity) {
    return values.firstWhere(
      (record) => record.entity == entity,
      orElse: () => RecordType.deviceUsage
    );
  }
}