import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import '../../../../core/utils/pose_utils.dart';
import '../../domain/entities/stage_state.dart';

class StageProvider extends ChangeNotifier {
  StageState _state = const StageState();
  StageState get state => _state;

  Size get imageSize => _imageSize; 

  int _stageNumber = 1;
  Timer? _gameTimer;
  Timer? _feedbackTimer;
  DateTime? _startTime;
  Pose? _currentPose;
  Size _imageSize = const Size(1280, 720);

  /// callback — stage screen ผูกไว้ใน initCamera()
  VoidCallback? onTimeUp;

  String _phase = 'DOWN';
  String _prevPhase = 'DOWN';

  // ── Smoothing ────────────────────────────────────
  // เก็บ smoothed positions เพื่อลด jitter
  final Map<PoseLandmarkType, Offset> _smoothed = {};
  static const double _alpha = 0.35; // EMA factor: ต่ำ = smooth มาก, สูง = responsive มาก

  Pose? get currentPose => _currentPose;

  /// คืน smoothed map ทั้งหมด — ส่งเข้า PosePainter / AvatarPainter
  Map<PoseLandmarkType, Offset> get smoothedMap => _smoothed;
  int get stageNumber => _stageNumber;
  bool get isRunning => _gameTimer?.isActive ?? false;

  static const double catZoneFraction = 0.32;
  static const double cowZoneFraction = 0.60;
  static const double hipZoneFraction = 0.52;

  // ── Setup ────────────────────────────────────────

  void setStage(int stage) {
    _stageNumber = stage;
    _reset();
  }

  void setImageSize(Size size) {
    _imageSize = size;
  }

  // ── Game loop ────────────────────────────────────

  void startGame() {
    _startTime = DateTime.now();
    _gameTimer = Timer.periodic(const Duration(milliseconds: 33), _tick);
  }

  void _tick(Timer timer) {
    final elapsed =
        DateTime.now().difference(_startTime!).inMilliseconds / 1000.0;
    final timeLeft =
        math.max(0.0, PoseUtils.gameDurationSeconds - elapsed);

    _state = _state.copyWith(
      timeLeft: timeLeft,
      animTime: _state.animTime + 0.033,
      flashAlpha: math.max(0.0, _state.flashAlpha - 0.025),
    );

    notifyListeners();

    if (timeLeft <= 0) {
      timer.cancel();
      // ใช้ addPostFrameCallback เพื่อไม่เรียก setState ระหว่าง build
      WidgetsBinding.instance.addPostFrameCallback((_) => onTimeUp?.call());
    }
  }

  void stopGame() {
    _gameTimer?.cancel();
    _feedbackTimer?.cancel();
  }

  double get elapsedSeconds => _startTime == null
      ? 0
      : DateTime.now().difference(_startTime!).inMilliseconds / 1000.0;

  // ── Pose processing ──────────────────────────────

  void processPose(Pose? pose) {
    _currentPose = pose;
    if (pose == null) {
      notifyListeners();
      return;
    }

    // ── EMA smoothing ────────────────────────────
    for (final entry in pose.landmarks.entries) {
      final lm = entry.value;
      if (lm.likelihood < 0.25) continue;
      final cur = Offset(lm.x, lm.y);
      final prev = _smoothed[entry.key];
      _smoothed[entry.key] = prev == null
          ? cur
          : Offset(
              prev.dx + _alpha * (cur.dx - prev.dx),
              prev.dy + _alpha * (cur.dy - prev.dy),
            );
    }

    switch (_stageNumber) {
      case 1: _processStage1(pose);
      case 2: _processStage2(pose);
      case 3: _processStage3(pose);
    }

    notifyListeners();
  }

  // ── Stage 1: Cat-Cow ─────────────────────────────
  void _processStage1(Pose pose) {
    final lw = pose.landmarks[PoseLandmarkType.leftWrist];
    final rw = pose.landmarks[PoseLandmarkType.rightWrist];
    final ls = pose.landmarks[PoseLandmarkType.leftShoulder];
    final rs = pose.landmarks[PoseLandmarkType.rightShoulder];

    if (lw == null || rw == null || ls == null || rs == null) return;
    if (lw.likelihood < 0.4 || rw.likelihood < 0.4) return;

    final avgWristY    = (lw.y + rw.y) / 2;
    final avgShoulderY = (ls.y + rs.y) / 2;

    // ML Kit คืน pixel coordinates — threshold เป็น pixel (5% ของ image height)
    final thresh = 0.05;  
    String cur;
    if (avgWristY < avgShoulderY - thresh) {
      cur = 'UP';
    } else if (avgWristY > avgShoulderY + thresh) {
      cur = 'DOWN';
    } else {
      cur = _phase;
    }

    int newHoldFrames = _state.holdFrames;

    if (cur == _phase) {
      newHoldFrames++;
    } else {
      newHoldFrames = 0;
      _phase = cur;
    }

    int    newReps     = _state.reps;
    String newFeedback = _state.feedback;
    double newFlash    = _state.flashAlpha;

    if (newHoldFrames == StageState.holdThreshold) {
      if (_phase == 'UP' && _prevPhase == 'DOWN') {
        newFeedback = 'CAT — Good! Now lower hands DOWN';
        newFlash    = 0.18;
        _prevPhase  = 'UP';
        _triggerFeedbackClear();
      } else if (_phase == 'DOWN' && _prevPhase == 'UP') {
        newReps     = _state.reps + 1;
        newFeedback = 'COW — Rep $newReps complete!';
        newFlash    = 0.22;
        _prevPhase  = 'DOWN';
        _triggerFeedbackClear();
      }
    }

    _state = _state.copyWith(
      holdFrames: newHoldFrames,
      reps:       newReps,
      feedback:   newFeedback,
      flashAlpha: newFlash,
    );
  }

  // ── Stage 2: Lateral Side Reach ──────────────────
  void _processStage2(Pose pose) {
    final isLeft    = _state.targetSide == DetectionSide.left;
    // front camera mirror: isLeft UI → rightWrist จริง
    // front camera mirror: isLeft UI = rightWrist ใน landmark
    // แต่เนื่องจากแก้ rotation270 แล้ว mirror ถูกต้อง = leftWrist
    // แก้ใน _processStage2() และ _processStage3()
    final wristType = isLeft
        ? PoseLandmarkType.rightWrist  // isLeft UI = rightWrist ใน ML Kit
        : PoseLandmarkType.leftWrist;

    final wrist = pose.landmarks[wristType];
    if (wrist == null || wrist.likelihood < 0.4) return;

    // painter flip X: isLeft UI → ขวาของ image (0.82)
    final targetX = isLeft ? _imageSize.width * 0.82 : _imageSize.width * 0.18;
    final targetY = _imageSize.height * 0.50;
    final baseRadius = _imageSize.width * 0.12; // 12% ของความกว้าง image

    final dx = wrist.x - targetX;
    final dy = wrist.y - targetY;
    final inCircle = (dx * dx + dy * dy) < (baseRadius * baseRadius);

    int            newHoldFrames = inCircle
        ? _state.holdFrames + 1
        : math.max(0, _state.holdFrames - 1);
    bool           newReached  = _state.reached;
    int            newReps     = _state.reps;
    String         newFeedback = _state.feedback;
    double         newFlash    = _state.flashAlpha;
    DetectionSide  newSide     = _state.targetSide;

    if (newHoldFrames >= StageState.holdThreshold && !newReached) {
      newReached  = true;
      newReps     = _state.reps + 1;
      newFeedback = '${isLeft ? 'Left' : 'Right'} arm reached! Rep $newReps';
      newFlash    = 0.18;
      newSide     = isLeft ? DetectionSide.right : DetectionSide.left;
      newHoldFrames = 0;
      _triggerFeedbackClear();
    } else if (!inCircle) {
      newReached = false;
    }

    _state = _state.copyWith(
      holdFrames: newHoldFrames,
      reached:    newReached,
      reps:       newReps,
      feedback:   newFeedback,
      flashAlpha: newFlash,
      targetSide: newSide,
    );
  }

  // ── Stage 3: Marching Core Drill ─────────────────
  void _processStage3(Pose pose) {
    final lHip = pose.landmarks[PoseLandmarkType.leftHip];
    final rHip = pose.landmarks[PoseLandmarkType.rightHip];
    if (lHip == null || rHip == null) return;

    // ML Kit pixel → normalized
    final hy = (lHip.y + rHip.y) / 2 / _imageSize.height;
    final isLeft = _state.targetSide == DetectionSide.left;

    // Python flip ไว้แล้ว → LEFT=LEFT, แต่ Flutter กล้องหน้า mirror
    // → isLeft UI = rightKnee ใน ML Kit (เหมือนเดิม)
    final knee = isLeft
        ? pose.landmarks[PoseLandmarkType.rightKnee]
        : pose.landmarks[PoseLandmarkType.leftKnee];
    if (knee == null || knee.likelihood < 0.35) return;

    // normalized เหมือน Python: lk.y < hy - 0.10
    final kneeNorm = knee.y / _imageSize.height;
    final ok = kneeNorm < hy - 0.10;

    int           newHoldFrames = ok ? _state.holdFrames + 1 : math.max(0, _state.holdFrames - 1);
    bool          newReached    = _state.reached;
    int           newReps       = _state.reps;
    String        newFeedback   = _state.feedback;
    double        newFlash      = _state.flashAlpha;
    DetectionSide newSide       = _state.targetSide;

    if (newHoldFrames >= StageState.holdThreshold && !newReached) {
      newReached    = true;
      newReps       = _state.reps + 1;
      newFeedback   = '${isLeft ? 'Left' : 'Right'} knee lifted! Rep $newReps';
      newFlash      = 0.18;
      newSide       = isLeft ? DetectionSide.right : DetectionSide.left;
      newHoldFrames = 0;
      _triggerFeedbackClear();
    } else if (!ok) {
      newReached = false;
    }

    _state = _state.copyWith(
      holdFrames: newHoldFrames,
      reached:    newReached,
      reps:       newReps,
      feedback:   newFeedback,
      flashAlpha: newFlash,
      targetSide: newSide,
    );
  }

  // ── Helpers ──────────────────────────────────────

  void _triggerFeedbackClear() {
    _feedbackTimer?.cancel();
    _feedbackTimer = Timer(const Duration(seconds: 2), () {
      _state = _state.copyWith(feedback: '');
      notifyListeners();
    });
  }

  double hipLevelY(double screenHeight) {
    final lHip = _currentPose?.landmarks[PoseLandmarkType.leftHip];
    final rHip = _currentPose?.landmarks[PoseLandmarkType.rightHip];
    if (lHip == null || rHip == null) return screenHeight * hipZoneFraction;
    // normalized เหมือน Python: hy = (lh.y + rh.y) / 2
    final hy = (lHip.y + rHip.y) / 2 / _imageSize.height;
    return hy * screenHeight;
  }

  Offset targetCircleCenter(double screenW, double screenH) {
    final isLeft = _state.targetSide == DetectionSide.left;
    // front camera mirror แก้แล้ว: isLeft UI = ซ้ายหน้าจอ user
    return Offset(isLeft ? screenW * 0.18 : screenW * 0.82, screenH * 0.50);
  }

  double targetCircleRadius() =>
      44.0 + 8.0 * math.sin(_state.animTime * 4);

  // ── Reset ────────────────────────────────────────
  void _reset() {
    stopGame();
    _state      = const StageState();
    _phase      = 'DOWN';
    _prevPhase  = 'DOWN';
    _currentPose = null;
    _startTime   = null;
    onTimeUp     = null;
    _smoothed.clear();
  }

  @override
  void dispose() {
    stopGame();
    super.dispose();
  }
}