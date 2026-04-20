import '../../../../../shared/entities/flexiback.dart';

enum DeviceChallengesType {
  normal (
    entity: "normal",
    duration: Flexiback.deviceNormalNofityDuration
  ),
  custom (
    entity: "custom",
    min: Flexiback.minCustomNofityDuration,
    max: Flexiback.maxCustomlNofityDuration,
  ),
  hard (
    entity: "hard",
  );

  final String entity;
  final Duration? duration;

  final Duration? min;
  final Duration? max;

  const DeviceChallengesType({
    required this.entity,
    this.duration,
    this.min,
    this.max
  });
}