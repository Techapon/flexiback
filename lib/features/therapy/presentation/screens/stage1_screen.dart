import 'dart:math' as math;
import 'package:camera/camera.dart';
import 'package:flexiback/features/therapy/presentation/screens/virtual_bg_painter.dart' show VirtualBgWidget;
import 'package:flutter/material.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import 'package:provider/provider.dart';
import '../../../../config/theme/colors/app_color.dart';
import '../../domain/entities/stage_state.dart';
import '../../domain/entities/therapy_session.dart';
import '../providers/therapy_provider.dart';
import '../providers/stage_provider.dart';
import '../widgets/hud_widget.dart';
import '../widgets/pose_painter.dart';
import 'package:flutter/foundation.dart';

/// Stage 1 — Cat-Cow Mobilisation
/// Python: run_stage1() — skeleton + zone lines + direction cue

class Stage1Screen extends StatefulWidget {
  const Stage1Screen({super.key});
  // key ส่งมาจาก TherapyScreen เพื่อ force rebuild เมื่อ stage เปลี่ยน

  @override
  State<Stage1Screen> createState() => _Stage1ScreenState();
}

class _Stage1ScreenState extends State<Stage1Screen> {
  CameraController? _cam;
  PoseDetector? _detector;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    final cameras = await availableCameras();
    final front = cameras.firstWhere(
      (c) => c.lensDirection == CameraLensDirection.front,
      orElse: () => cameras.first,
    );
    _cam = CameraController(front, ResolutionPreset.high, enableAudio: false);
    await _cam!.initialize();

    _detector = PoseDetector(
      options: PoseDetectorOptions(mode: PoseDetectionMode.stream),
    );

    final stage = context.read<StageProvider>();
    stage.setStage(1);
    stage.setImageSize(Size(
      _cam!.value.previewSize!.height,
      _cam!.value.previewSize!.width,
    ));

    // ผูก callback — เมื่อหมดเวลาให้แจ้ง TherapyProvider
    stage.onTimeUp = () {
      if (!mounted) return;
      final therapy = context.read<TherapyProvider>();
      if (therapy.status == SessionStatus.playing) {
        therapy.onStageDone(stage.state.reps, stage.elapsedSeconds);
      }
    };

    _cam!.startImageStream(_onFrame);
    if (mounted) setState(() {});
  }

  Future<void> _onFrame(CameraImage img) async {
    if (_busy) return;
    _busy = true;
    try {
      final inputImage = _toInputImage(img);
      // print('📷 format: ${img.format.raw}, planes: ${img.planes.length}, size: ${img.width}x${img.height}');
      if (inputImage == null) { print('❌ inputImage null'); return; }
      
      final poses = await _detector!.processImage(inputImage);
      if (poses.isNotEmpty) {
        print('🖼 previewSize: ${_cam!.value.previewSize}');
        print('🦴 nose x: ${poses.first.landmarks[PoseLandmarkType.nose]?.x}');
        print('📐 imageSize in provider: ${context.read<StageProvider>().state}');
      }
      if (!mounted) return;
      context.read<StageProvider>().processPose(poses.isNotEmpty ? poses.first : null);
    } finally {
      _busy = false;
    }
  }

  InputImage? _toInputImage(CameraImage img) {
    try {
      final int width  = img.width;
      final int height = img.height;

      final yPlane = img.planes[0];
      final uPlane = img.planes[1];
      final vPlane = img.planes[2];

      // NV21 size = Y + VU
      final nv21 = Uint8List(width * height * 3 ~/ 2);

      // copy Y row by row (ตาม rowStride จริง)
      int dstIndex = 0;
      for (int row = 0; row < height; row++) {
        final srcStart = row * yPlane.bytesPerRow;
        nv21.setRange(dstIndex, dstIndex + width, yPlane.bytes, srcStart);
        dstIndex += width;
      }

      // interleave VU row by row
      final uvHeight = height ~/ 2;
      final uvWidth  = width  ~/ 2;
      for (int row = 0; row < uvHeight; row++) {
        for (int col = 0; col < uvWidth; col++) {
          final vIdx = row * vPlane.bytesPerRow + col * vPlane.bytesPerPixel!;
          final uIdx = row * uPlane.bytesPerRow + col * uPlane.bytesPerPixel!;
          nv21[dstIndex++] = vPlane.bytes[vIdx];
          nv21[dstIndex++] = uPlane.bytes[uIdx];
        }
      }

      return InputImage.fromBytes(
        bytes: nv21,
        metadata: InputImageMetadata(
          size: Size(width.toDouble(), height.toDouble()),
          rotation: InputImageRotation.rotation270deg,
          format: InputImageFormat.nv21,
          bytesPerRow: width,
        ),
      );
    } catch (e) {
      print('❌ toInputImage error: $e');
      return null;
    }
  }

  @override
  void dispose() {
    _cam?.dispose();
    _detector?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final therapy = context.watch<TherapyProvider>();
    final stage   = context.watch<StageProvider>();
    final state   = stage.state;

    if (_cam == null || !_cam!.value.isInitialized) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final size = MediaQuery.of(context).size;

    

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // ── Virtual Background ───────────────────────
          VirtualBgWidget(stage: 1, animTime: state.animTime),

          // ── Camera feed (semi-transparent) ───────────
          Opacity(opacity: 0.55, child: CameraPreview(_cam!)),

          // ── Zone lines (CAT/COW) ─────────────────────
          CustomPaint(size: Size.infinite, painter: Stage1ZonePainter()),

          // ── Skeleton ─────────────────────────────────
          if (stage.currentPose != null)
          
            CustomPaint(
              size: Size.infinite,
              painter: PosePainter(
                pose: stage.currentPose!,
                imageSize: Size(
                  _cam!.value.previewSize!.height,
                  _cam!.value.previewSize!.width,
                ),
                animTime: state.animTime,
                smoothed: stage.smoothedMap,
              ),
            ),

          // ── Zone badges ──────────────────────────────
          _ZoneBadges(),

          // ── Direction cue — Python: show_arrow ───────
          _DirectionCue(state: state),

          // ── Flash ────────────────────────────────────
          FlashOverlay(
            alpha: state.flashAlpha,
            color: state.targetSide == DetectionSide.left
                ? AiAppColors.teal
                : AiAppColors.gold,
          ),

          // ── Feedback ─────────────────────────────────
          FeedbackWidget(
            text: state.feedback,
            color: AiAppColors.gold,
          ),

          // ── HowTo Panel ──────────────────────────────
          HowToPanel(lines: const [
            '1. Stand facing camera',
            '2. Raise BOTH hands UP',
            '   above TEAL line (Cat)',
            '3. Lower BOTH hands DOWN',
            '   below GOLD line (Cow)',
            '4. Alternate slowly',
            '   Mobilises the spine',
          ]),

          // ── HUD top bar ──────────────────────────────
          Positioned(
            top: 0, left: 0, right: 0,
            child: HudWidget(
              stage: 1,
              reps: state.reps,
              timeLeft: state.timeLeft,
              stageName: 'Cat-Cow Mobilisation',
            ),
          ),

          // ── Intro overlay ────────────────────────────
          if (therapy.status == SessionStatus.waiting)
            StageIntroOverlay(
              stage: 1,
              name: therapy.currentStageName,
              description: therapy.currentStageDescription,
              onStart: () {
                therapy.startCurrentStage();
                stage.startGame();
              },
            ),

          // ── Stage complete overlay ────────────────────
          if (therapy.status == SessionStatus.stageDone)
            StageCompleteOverlay(
              stage: 1,
              score: stage.state.reps,
              hasNext: true,
              onNext: () => context.read<TherapyProvider>().goToNextStage(),
            ),
        ],
      ),
    );
  }
}

// ── Direction cue widget (animated) ─────────────────────────────
class _DirectionCue extends StatelessWidget {
  final StageState state;
  const _DirectionCue({required this.state});

  @override
  Widget build(BuildContext context) {
    // Python: phase == "DOWN" → raise UP, else lower DOWN
    // stage_provider ใช้ feedback แทน phase ตรงๆ
    final goingUp = !state.feedback.contains('CAT');
    final text  = goingUp ? 'Raise UP  ↑' : '↓  Lower DOWN';
    final color = goingUp ? AiAppColors.teal : AiAppColors.gold;
    final dy    = math.sin(state.animTime * 2.5) * 32;

    return Positioned(
      top: HudWidget.hudHeight + MediaQuery.of(context).size.height * 0.35 + dy,
      left: 0, right: 0,
      child: Center(
        child: Stack(
          children: [
            Text(text, style: const TextStyle(
              color: Colors.black, fontSize: 32,
              fontWeight: FontWeight.w900,
              shadows: [Shadow(offset: Offset(2,2))],
            )),
            Text(text, style: TextStyle(
              color: color, fontSize: 32,
              fontWeight: FontWeight.w900,
            )),
          ],
        ),
      ),
    );
  }
}

// ── Zone badges ─────────────────────────────────────────────────
class _ZoneBadges extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    return Stack(children: [
      _badge(context, y: h * kCatZoneFraction - 28,
             text: 'CAT zone — raise above', color: AiAppColors.teal),
      _badge(context, y: h * kCowZoneFraction + 4,
             text: 'COW zone — lower below', color: AiAppColors.gold),
    ]);
  }

  Widget _badge(BuildContext context, {required double y, required String text, required Color color}) {
    return Positioned(
      top: y, left: 10,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: const Color(0xFF080812).withOpacity(0.85),
          border: Border.all(color: color, width: 1),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(text, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.bold)),
      ),
    );
  }
}