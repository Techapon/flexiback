import 'stage_result.dart';

/// สถานะของ session การออกกำลังกายทั้งหมด
/// เก็บ current stage, ผลของแต่ละ stage และสถานะการเล่น

enum SessionStatus {
  idle,       // ยังไม่เริ่ม
  waiting,    // รอกด N เพื่อเริ่ม stage
  playing,    // กำลังเล่นอยู่
  stageDone,  // จบ stage แล้ว รอไปต่อ
  completed,  // จบทุก stage แล้ว
  quit,       // ออกกลางคัน
}

class TherapySession {
  final int currentStage;
  final SessionStatus status;
  final List<StageResult> stageResults;
  final DateTime? startedAt;
  final DateTime? endedAt; // เพิ่ม

  const TherapySession({
    this.currentStage = 1,
    this.status = SessionStatus.idle,
    this.stageResults = const [],
    this.startedAt,
    this.endedAt, // เพิ่ม
  });

  static const int totalStages = 3;

  /// reps รวมทุก stage
  int get totalReps =>
      stageResults.fold(0, (sum, r) => sum + r.reps);

  /// scores แต่ละ stage — ใช้แสดงใน final_screen
  List<int> get scores => stageResults.map((r) => r.score).toList();

  /// ผลของ stage ปัจจุบัน (ถ้ามี)
  StageResult? get currentStageResult {
    try {
      return stageResults.firstWhere((r) => r.stageNumber == currentStage);
    } catch (_) {
      return null;
    }
  }

  bool get isLastStage => currentStage == totalStages;

  TherapySession copyWith({
    int? currentStage,
    SessionStatus? status,
    List<StageResult>? stageResults,
    DateTime? startedAt,
    DateTime? endedAt,
  }) {
    return TherapySession(
      currentStage: currentStage ?? this.currentStage,
      status: status ?? this.status,
      stageResults: stageResults ?? this.stageResults,
      startedAt: startedAt ?? this.startedAt,
      endedAt: endedAt ?? this.endedAt,
    );
  }

  /// เพิ่มผล stage ใหม่เข้าไปใน list
  TherapySession addStageResult(StageResult result) {
    final updated = List<StageResult>.from(stageResults)
      ..removeWhere((r) => r.stageNumber == result.stageNumber)
      ..add(result);
    return copyWith(stageResults: updated);
  }

  Map<String, dynamic> toJson() => {
        'current_stage': currentStage,
        'status': status.name,
        'stage_results': stageResults.map((r) => r.toJson()).toList(),
        'started_at': startedAt?.toIso8601String(),
      };

  @override
  String toString() =>
      'TherapySession(stage: $currentStage, status: $status, totalReps: $totalReps)';
}