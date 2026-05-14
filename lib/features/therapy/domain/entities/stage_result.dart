/// ผลลัพธ์ของแต่ละ stage หลังจบการเล่น
/// ใช้เก็บ reps ที่ทำได้และเวลาที่ใช้

class StageResult {
  final int stageNumber;
  final int reps;
  final double durationSeconds;

  const StageResult({
    required this.stageNumber,
    required this.reps,
    required this.durationSeconds,
  });

  /// score คำนวณจาก reps (ใช้แสดงใน complete screen)
  int get score => reps;

  StageResult copyWith({
    int? stageNumber,
    int? reps,
    double? durationSeconds,
  }) {
    return StageResult(
      stageNumber: stageNumber ?? this.stageNumber,
      reps: reps ?? this.reps,
      durationSeconds: durationSeconds ?? this.durationSeconds,
    );
  }

  Map<String, dynamic> toJson() => {
        'stage_number': stageNumber,
        'reps': reps,
        'duration_seconds': durationSeconds,
      };

  factory StageResult.fromJson(Map<String, dynamic> json) => StageResult(
        stageNumber: json['stage_number'] as int,
        reps: json['reps'] as int,
        durationSeconds: (json['duration_seconds'] as num).toDouble(),
      );

  @override
  String toString() =>
      'StageResult(stage: $stageNumber, reps: $reps, duration: ${durationSeconds.toStringAsFixed(1)}s)';
}