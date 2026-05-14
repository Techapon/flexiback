import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import '../../../../core/utils/pose_utils.dart';
import '../../domain/entities/stage_state.dart';

/// Provider real-time — อัพเดทระหว่างเล่นทุก frame
/// เทียบกับ Python: run_stage1/2/3() loop
///
/// แต่ละ stage ใช้ provider ตัวเดียวกัน เปลี่ยน behavior ด้วย stageNumber

class StageProvider extends ChangeNotifier {
  // ── State ────────────────────────────────────────
  StageState _state = const StageState();
  StageState get state => _state;

  // ── Internal ─────────────────────────────────────
  int _stageNumber = 1;
  Timer? _gameTimer;
  Timer? _feedbackTimer;
  DateTime? _startTime;
  Pose? _currentPose;
  Size _imageSize = const Size(1280, 720);
  VoidCallback? onTimeUp; // callback แจ้งว่าหมดเวลา

  // Stage 1 specific
  String _phase = 'DOWN';       // Python: phase
  String _prevPhase = 'DOWN';   // Python: prev_phase

  Pose? get currentPose => _currentPose;
  int get stageNumber => _stageNumber;
  bool get isRunning => _gameTimer?.isActive ?? false;

  // ── Zone lines (fraction of screen height) ───────
  /// Python: zu = int(h*0.32) — TEAL line (CAT zone)
  static const double catZoneFraction = 0.32;

  /// Python: zl = int(h*0.60) — GOLD line (COW zone)
  static const double cowZoneFraction = 0.60;

  /// Python: hip_ly = int(hy*h) — dynamic, แต่ fallback = 0.52
  static const double hipZoneFraction = 0.52;

  // ── Setup ─────────────────────────────────────────

  void setStage(int stage) {
    _stageNumber = stage;
    _reset();
  }

  void setImageSize(Size size) {
    _imageSize = size;
  }

  // ── Game loop ─────────────────────────────────────

  /// เริ่ม timer countdown — Python: t0 = time.time()
  void startGame() {
    _startTime = DateTime.now();
    _gameTimer = Timer.periodic(const Duration(milliseconds: 33), _tick);
  }

  void _tick(Timer timer) {
    final elapsed = DateTime.now().difference(_startTime!).inMilliseconds / 1000.0;
    final timeLeft = math.max(0.0, PoseUtils.gameDurationSeconds - elapsed);
    final animTime = _state.animTime + 0.033;

    _state = _state.copyWith(
      timeLeft: timeLeft,
      animTime: animTime,
      // fade flash
      flashAlpha: math.max(0.0, _state.flashAlpha - 0.025),
    );

    if (timeLeft <= 0) {
      timer.cancel();
      // แจ้ง TherapyProvider ว่า stage จบแล้ว
      WidgetsBinding.instance.addPostFrameCallback((_) => onTimeUp?.call());
    }
    notifyListeners();
  }

  void stopGame() {
    _gameTimer?.cancel();
    _feedbackTimer?.cancel();
  }

  double get elapsedSeconds =>
      _startTime == null ? 0 : DateTime.now().difference(_startTime!).inMilliseconds / 1000.0;

  // ── Pose processing ───────────────────────────────

  /// เรียกทุกครั้งที่ได้ frame ใหม่จาก ML Kit
  void processPose(Pose? pose) {
    _currentPose = pose;
    if (pose == null) return;

    switch (_stageNumber) {
      case 1: _processStage1(pose); break;
      case 2: _processStage2(pose); break;
      case 3: _processStage3(pose); break;
    }
  }

  // ── Stage 1: Cat-Cow ──────────────────────────────
  /// Python: run_stage1() pose logic block
  void _processStage1(Pose pose) {
    final w = _imageSize.width;
    final h = _imageSize.height;

    final lw = pose.landmarks[PoseLandmarkType.leftWrist];
    final rw = pose.landmarks[PoseLandmarkType.rightWrist];
    final ls = pose.landmarks[PoseLandmarkType.leftShoulder];
    final rs = pose.landmarks[PoseLandmarkType.rightShoulder];

    if (lw == null || rw == null || ls == null || rs == null) return;
    if (lw.likelihood < 0.4 || rw.likelihood < 0.4) return;

    final avgWristY  = (lw.y + rw.y) / 2;
    final avgShoulderY = (ls.y + rs.y) / 2;

    String cur;
    if (avgWristY < avgShoulderY - 0.05) {
      cur = 'UP';
    } else if (avgWristY > avgShoulderY + 0.05) {
      cur = 'DOWN';
    } else {
      cur = _phase;
    }

    int newHoldFrames = _state.holdFrames;
    String newPhase = _phase;

    if (cur == _phase) {
      newHoldFrames++;
    } else {
      newHoldFrames = 0;
      newPhase = cur;
      _phase = cur;
    }

    int newReps = _state.reps;
    String newFeedback = _state.feedback;
    double newFlash = _state.flashAlpha;

    if (newHoldFrames == StageState.holdThreshold) {
      if (_phase == 'UP' && _prevPhase == 'DOWN') {
        newFeedback = 'CAT - Good! Now lower hands DOWN';
        newFlash = 0.18;
        _prevPhase = 'UP';
        _triggerFeedbackClear();
      } else if (_phase == 'DOWN' && _prevPhase == 'UP') {
        newReps = _state.reps + 1;
        newFeedback = 'COW - Rep $newReps complete!';
        newFlash = 0.22;
        _prevPhase = 'DOWN';
        _triggerFeedbackClear();
      }
    }

    _state = _state.copyWith(
      holdFrames: newHoldFrames,
      reps: newReps,
      feedback: newFeedback,
      flashAlpha: newFlash,
    );
  }

  // ── Stage 2: Lateral Side Reach ───────────────────
  /// Python: run_stage2() pose logic block
  void _processStage2(Pose pose) {
    final w = _imageSize.width;
    final h = _imageSize.height;

    final isLeft = _state.targetSide == DetectionSide.left;
    final wristType = isLeft
        ? PoseLandmarkType.leftWrist
        : PoseLandmarkType.rightWrist;

    final wrist = pose.landmarks[wristType];
    if (wrist == null || wrist.likelihood < 0.4) return;

    // target circle position — Python: tcx, tcy
    final targetX = isLeft ? w * 0.18 : w * 0.82;
    final targetY = h * 0.50;
    final targetCenter = Offset(targetX, targetY);
    final wristPos = Offset(wrist.x * w, wrist.y * h);

    // Python: pr = int(44 + 8*sin(...)) — pulsing radius, use base 44
    const baseRadius = 52.0;
    final inCircle = PoseUtils.isInsideCircle(wristPos, targetCenter, baseRadius);

    int newHoldFrames = inCircle ? _state.holdFrames + 1 : math.max(0, _state.holdFrames - 1);
    bool newReached = _state.reached;
    int newReps = _state.reps;
    String newFeedback = _state.feedback;
    double newFlash = _state.flashAlpha;
    DetectionSide newSide = _state.targetSide;

    if (newHoldFrames >= StageState.holdThreshold && !newReached) {
      newReached = true;
      newReps = _state.reps + 1;
      final sideName = isLeft ? 'Left' : 'Right';
      newFeedback = '$sideName arm reached! Rep $newReps';
      newFlash = 0.18;
      newSide = isLeft ? DetectionSide.right : DetectionSide.left;
      newHoldFrames = 0;
      _triggerFeedbackClear();
    } else if (!inCircle) {
      newReached = false;
    }

    _state = _state.copyWith(
      holdFrames: newHoldFrames,
      reached: newReached,
      reps: newReps,
      feedback: newFeedback,
      flashAlpha: newFlash,
      targetSide: newSide,
    );
  }

  // ── Stage 3: Marching Core Drill ──────────────────
  /// Python: run_stage3() pose logic block
  void _processStage3(Pose pose) {
    final w = _imageSize.width;
    final h = _imageSize.height;

    final lHip  = pose.landmarks[PoseLandmarkType.leftHip];
    final rHip  = pose.landmarks[PoseLandmarkType.rightHip];
    final lKnee = pose.landmarks[PoseLandmarkType.leftKnee];
    final rKnee = pose.landmarks[PoseLandmarkType.rightKnee];

    if (lHip == null || rHip == null) return;

    final hipY = (lHip.y + rHip.y) / 2;   // normalized
    final isLeft = _state.targetSide == DetectionSide.left;

    final knee = isLeft ? lKnee : rKnee;
    if (knee == null || knee.likelihood < 0.35) return;

    // Python: ok = lk.y < hy - 0.10
    final ok = knee.y < hipY - 0.10;

    int newHoldFrames = ok
        ? _state.holdFrames + 1
        : math.max(0, _state.holdFrames - 1);
    bool newReached = _state.reached;
    int newReps = _state.reps;
    String newFeedback = _state.feedback;
    double newFlash = _state.flashAlpha;
    DetectionSide newSide = _state.targetSide;

    if (newHoldFrames >= StageState.holdThreshold && !newReached) {
      newReached = true;
      newReps = _state.reps + 1;
      final sideName = isLeft ? 'Left' : 'Right';
      newFeedback = '$sideName knee lifted! Rep $newReps';
      newFlash = 0.18;
      newSide = isLeft ? DetectionSide.right : DetectionSide.left;
      newHoldFrames = 0;
      _triggerFeedbackClear();
    } else if (!ok) {
      newReached = false;
    }

    _state = _state.copyWith(
      holdFrames: newHoldFrames,
      reached: newReached,
      reps: newReps,
      feedback: newFeedback,
      flashAlpha: newFlash,
      targetSide: newSide,
    );
  }

  // ── Feedback auto-clear ───────────────────────────
  void _triggerFeedbackClear() {
    _feedbackTimer?.cancel();
    _feedbackTimer = Timer(const Duration(seconds: 2), () {
      _state = _state.copyWith(feedback: '');
      notifyListeners();
    });
  }

  // ── Helpers ───────────────────────────────────────

  /// hip Y position เป็น pixel — ใช้ใน Stage 3 painter วาดเส้น hip
  double hipLevelY(double screenHeight) {
    if (_currentPose == null) return screenHeight * hipZoneFraction;
    final lHip = _currentPose!.landmarks[PoseLandmarkType.leftHip];
    final rHip = _currentPose!.landmarks[PoseLandmarkType.rightHip];
    if (lHip == null || rHip == null) return screenHeight * hipZoneFraction;
    return ((lHip.y + rHip.y) / 2) * screenHeight;
  }

  /// Stage 2 target circle center
  Offset targetCircleCenter(double w, double h) {
    final isLeft = _state.targetSide == DetectionSide.left;
    return Offset(isLeft ? w * 0.18 : w * 0.82, h * 0.50);
  }

  /// Stage 2 pulsing radius — Python: pr = int(44 + 8*sin(pt2*4))
  double targetCircleRadius() {
    return 44.0 + 8.0 * math.sin(_state.animTime * 4);
  }

  // ── Reset ─────────────────────────────────────────
  void _reset() {
    stopGame();
    _state = const StageState();
    _phase = 'DOWN';
    _prevPhase = 'DOWN';
    _currentPose = null;
    _startTime = null;
  }

  @override
  void dispose() {
    stopGame();
    super.dispose();
  }
}