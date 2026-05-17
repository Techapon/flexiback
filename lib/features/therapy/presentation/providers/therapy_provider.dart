import 'package:flexiback/features/therapy/data/repositories/therapy_repository_impl.dart';
import 'package:flexiback/features/therapy/domain/usecases/upload_session_usecase.dart';
import 'package:flutter/material.dart';

import '../../data/datasources/therapy_datasource.dart';
import '../../domain/entities/stage_result.dart';
import '../../domain/entities/therapy_session.dart';


/// Provider หลัก — ควบคุม session flow ทั้งหมด
/// เทียบกับ Python: main(), wait_n(), scores list
///
/// Lifecycle:
/// idle → waiting → playing → stageDone → waiting → ... → completed

class TherapyProvider extends ChangeNotifier {
  final UploadSessionUsecase uploadSessionUsecase = UploadSessionUsecase(TherapyRepositoryImpl(TherapyDatasource()));

  TherapySession _session = const TherapySession();

  TherapySession get session => _session;
  int get currentStage => _session.currentStage;
  SessionStatus get status => _session.status;
  List<int> get scores => _session.scores;
  bool get isCompleted => _session.status == SessionStatus.completed;
  

  // ── Stage metadata ───────────────────────────────
  static const _stageNames = [
    'Cat-Cow Mobilisation',
    'Lateral Side Reach',
    'Marching Core Drill',
  ];

  static const _stageDescriptions = [
    [
      'Raise BOTH hands UP above TEAL line  (Cat pose)',
      'Lower BOTH hands DOWN below GOLD line (Cow pose)',
      'Alternate slowly — mobilises the spine',
    ],
    [
      'Reach ONE arm sideways to the glowing circle',
      'Stretches Quadratus Lumborum (side-back muscle)',
      'Alternate left and right',
    ],
    [
      'Lift each KNEE above the purple hip line alternately',
      'Activates core & deep back stabilisers',
      'Hold near a wall if balance is needed',
    ],
  ];

  String get currentStageName =>
      _stageNames[currentStage - 1];

  List<String> get currentStageDescription =>
      _stageDescriptions[currentStage - 1];

  // ── Actions ──────────────────────────────────────

  /// เริ่ม session ใหม่ทั้งหมด
  void startSession() {
    _session = TherapySession(
      currentStage: 1,
      status: SessionStatus.waiting,
      startedAt: DateTime.now(),
    );
    notifyListeners();
  }

  /// Python: key == ord('n') — กด N เพื่อเริ่ม stage
  void startCurrentStage() {
    if (_session.status != SessionStatus.waiting) return;
    _session = _session.copyWith(status: SessionStatus.playing);
    notifyListeners();
  }

  /// Python: return reps, "done" — stage จบแล้ว บันทึกผล
  void onStageDone(int reps, double durationSeconds) {
    final result = StageResult(
      stageNumber: currentStage,
      reps: reps,
      durationSeconds: durationSeconds,
    );
    _session = _session
        .addStageResult(result)
        .copyWith(status: SessionStatus.stageDone);
    notifyListeners();
  }

  String? error;
  /// Python: key == ord('n') หลัง complete screen — ไป stage ถัดไป
  void goToNextStage() async {
    if (_session.status != SessionStatus.stageDone) return;

    if (_session.isLastStage) {
       _session = _session.copyWith(
        status: SessionStatus.completed,
        endedAt: DateTime.now(), // บันทึกเวลาจบ
      );

      // Save to DB
      try {
        uploadSessionUsecase(_session);
      } catch (e) {
        error = e.toString();
      }

    } else {
      _session = _session.copyWith(
        currentStage: currentStage + 1,
        status: SessionStatus.waiting,
      );  
    }
    notifyListeners();
  }

  /// Python: key == 27 (ESC)
  void quit() {
    _session = _session.copyWith(status: SessionStatus.quit);
    notifyListeners();
  }

  /// Reset กลับไปหน้าแรก
  void reset() {
    _session = const TherapySession();
    notifyListeners();
  }

  // ── Score helpers ────────────────────────────────

  /// Python: complete_screen — message ตาม score
  /// >= 12 = Excellent, >= 7 = Good, else = Keep trying
  static String scoreMessage(int score) {
    if (score >= 12) return 'Excellent! Great mobility!';
    if (score >= 7) return 'Good job! Keep practicing.';
    return 'Good start! A bit faster next time.';
  }

  /// stage names สำหรับ final screen
  static List<String> get stageNames => _stageNames;
}