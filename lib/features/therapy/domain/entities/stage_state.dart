/// State ระหว่างเล่น stage — อัพเดทแบบ real-time ทุก frame
/// แยกออกจาก TherapySession เพราะ update ถี่มาก (~30fps)

enum DetectionSide { left, right }

class StageState {
  // ── Timer ──────────────────────────────────────────
  final double timeLeft;      // วินาทีที่เหลือ (จาก 60.0)

  // ── Rep counting ───────────────────────────────────
  final int reps;
  final DetectionSide targetSide;   // ข้างที่ต้องทำตอนนี้
  final int holdFrames;             // Python: hf — frame ที่ hold ค้างไว้
  final bool reached;               // Python: reached — ทำท่าสำเร็จแล้ว

  // ── Feedback ───────────────────────────────────────
  final String feedback;            // ข้อความแสดงผล เช่น "Left knee lifted! Rep 3"
  final double flashAlpha;          // Python: flash — ความเข้มของ flash effect (0.0–1.0)

  // ── Animation ──────────────────────────────────────
  final double animTime;            // Python: anim — เวลา animation สะสม

  const StageState({
    this.timeLeft = 60.0,
    this.reps = 0,
    this.targetSide = DetectionSide.left,
    this.holdFrames = 0,
    this.reached = false,
    this.feedback = '',
    this.flashAlpha = 0.0,
    this.animTime = 0.0,
  });

  /// Python: THRESH = 6 — จำนวน frame ที่ต้อง hold ก่อนนับ rep
  static const int holdThreshold = 3;

  bool get isTimeUp => timeLeft <= 0;

  StageState copyWith({
    double? timeLeft,
    int? reps,
    DetectionSide? targetSide,
    int? holdFrames,
    bool? reached,
    String? feedback,
    double? flashAlpha,
    double? animTime,
  }) {
    return StageState(
      timeLeft: timeLeft ?? this.timeLeft,
      reps: reps ?? this.reps,
      targetSide: targetSide ?? this.targetSide,
      holdFrames: holdFrames ?? this.holdFrames,
      reached: reached ?? this.reached,
      feedback: feedback ?? this.feedback,
      flashAlpha: flashAlpha ?? this.flashAlpha,
      animTime: animTime ?? this.animTime,
    );
  }

  @override
  String toString() =>
      'StageState(timeLeft: ${timeLeft.toStringAsFixed(1)}, reps: $reps, side: $targetSide)';
}