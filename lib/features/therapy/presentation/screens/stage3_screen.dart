import 'dart:math' as math;
import 'dart:collection';
import 'package:camera/camera.dart';
import 'package:flexiback/features/therapy/presentation/screens/virtual_bg_painter.dart';
import 'package:flutter/foundation.dart';
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

class Stage3Screen extends StatefulWidget {
  const Stage3Screen({super.key});
  @override
  State<Stage3Screen> createState() => _Stage3ScreenState();
}

class _Stage3ScreenState extends State<Stage3Screen> {
  CameraController? _cam;
  PoseDetector? _detector;
  bool _busy = false;

  final Queue<Offset> _leftTrail  = Queue();
  final Queue<Offset> _rightTrail = Queue();
  static const int _maxTrail = 12;

  // image dimensions หลัง setImageSize (portrait): w=720, h=1280
  static const double _imgW = 720.0;
  static const double _imgH = 1280.0;

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
    stage.setStage(3);
    stage.setImageSize(Size(
      _cam!.value.previewSize!.height, // 720
      _cam!.value.previewSize!.width,  // 1280
    ));

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
      if (inputImage == null) return;
      final poses = await _detector!.processImage(inputImage);
      if (!mounted) return;
      if (poses.isNotEmpty) {
        _updateTrails(poses.first);
      }
      context.read<StageProvider>().processPose(poses.isNotEmpty ? poses.first : null);
      if (mounted) setState(() {});
    } finally {
      _busy = false;
    }
  }

  /// แปลง landmark pixel landscape → screen portrait + flip X
  /// rotation270: portrait_x = lm.y, portrait_y = imgH - lm.x
  Offset _lmToScreen(double lmX, double lmY, Size screenSize) {
    final px = screenSize.width  - (lmY / _imgW) * screenSize.width;  // flip X
    final py =                     (_imgH - lmX) / _imgH * screenSize.height;
    return Offset(px, py);
  }

  void _updateTrails(Pose pose) {
    final size = MediaQuery.of(context).size;
    final lk = pose.landmarks[PoseLandmarkType.leftKnee];
    final rk = pose.landmarks[PoseLandmarkType.rightKnee];

    // trail วาดบนหน้าจอ ต้องแปลง rotation270 + flip X
    // แต่ trail แสดง knee ที่ user เห็น → ใช้ leftKnee/rightKnee ตาม mirror
    // leftKnee ใน ML Kit = ขวาบนหน้าจอ (หลัง flip X)
    if (lk != null && lk.likelihood > 0.3) {
      final pt = _lmToScreen(lk.x, lk.y, size);
      _leftTrail.addLast(pt);
      if (_leftTrail.length > _maxTrail) _leftTrail.removeFirst();
    }
    if (rk != null && rk.likelihood > 0.3) {
      final pt = _lmToScreen(rk.x, rk.y, size);
      _rightTrail.addLast(pt);
      if (_rightTrail.length > _maxTrail) _rightTrail.removeFirst();
    }
  }

  InputImage? _toInputImage(CameraImage img) {
    try {
      final int width  = img.width;
      final int height = img.height;
      final yPlane = img.planes[0];
      final uPlane = img.planes[1];
      final vPlane = img.planes[2];

      final nv21 = Uint8List(width * height * 3 ~/ 2);
      int dstIndex = 0;

      for (int row = 0; row < height; row++) {
        final srcStart = row * yPlane.bytesPerRow;
        nv21.setRange(dstIndex, dstIndex + width, yPlane.bytes, srcStart);
        dstIndex += width;
      }

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
    final size    = MediaQuery.of(context).size;

    if (_cam == null || !_cam!.value.isInitialized) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final isLeft      = state.targetSide == DetectionSide.left;
    final hipY        = stage.hipLevelY(size.height);
    final activeColor = isLeft ? AiAppColors.gold : AiAppColors.coral;

    // tcx ตาม knee X:
    // isLeft UI → rightKnee ใน ML Kit (mirror)
    // rotation270 + flip X: portrait_x = screenW - (lm.y / imgW) * screenW
    final kneeKey = isLeft
        ? PoseLandmarkType.rightKnee
        : PoseLandmarkType.leftKnee;
    final smoothedKnee = stage.smoothedMap[kneeKey];
    final tcx = smoothedKnee != null
      ? size.width - smoothedKnee.dx * (size.width / _imgW)
      : isLeft ? size.width * 0.30 : size.width * 0.70;
    final tcy = hipY - size.height * 0.12;

    final circleRadius = 44.0 + 8.0 * math.sin(state.animTime * 4);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          VirtualBgWidget(stage: 3, animTime: state.animTime),
          Opacity(opacity: 0.55, child: CameraPreview(_cam!)),

          if (stage.currentPose != null)
            CustomPaint(
              painter: PosePainter(
                pose: stage.currentPose!,
                imageSize: Size(
                  _cam!.value.previewSize!.height, // 720
                  _cam!.value.previewSize!.width,  // 1280
                ),
                animTime: state.animTime,
                smoothed: stage.smoothedMap,
              ),
            ),

          CustomPaint(painter: HipLinePainter(hipY: hipY)),

          CustomPaint(
            painter: KneeTrailPainter(
              leftTrail:  _leftTrail.toList(),
              rightTrail: _rightTrail.toList(),
            ),
          ),

          CustomPaint(
            painter: Stage2TargetPainter(
              center: Offset(tcx, tcy),
              radius: circleRadius,
              holdProgress: (state.holdFrames / StageState.holdThreshold).clamp(0.0, 1.0),
              isLeft: isLeft,
              animTime: state.animTime,
            ),
          ),

          Positioned(
            top: tcy - circleRadius - 28,
            left: tcx - 40,
            child: Text('^ LIFT',
              style: TextStyle(color: activeColor, fontSize: 14, fontWeight: FontWeight.bold)),
          ),

          Positioned(
            bottom: 52, left: 0, right: 0,
            child: Center(
              child: Text(
                'Lift  ${isLeft ? 'LEFT' : 'RIGHT'}  knee',
                style: TextStyle(
                  color: activeColor, fontSize: 22, fontWeight: FontWeight.bold,
                  shadows: const [Shadow(color: Colors.black, offset: Offset(2,2), blurRadius: 4)],
                ),
              ),
            ),
          ),

          FlashOverlay(alpha: state.flashAlpha, color: AiAppColors.teal),
          FeedbackWidget(text: state.feedback, color: AiAppColors.teal),

          HowToPanel(lines: const [
            '1. Stand, feet hip-width',
            '2. Lift ONE knee HIGH',
            '   above purple line',
            '3. Hold until bar fills',
            '4. Lower & switch side',
            '5. Keep core tight',
            '   Activates deep back',
          ]),

          Positioned(
            top: 0, left: 0, right: 0,
            child: HudWidget(
              stage: 3, reps: state.reps,
              timeLeft: state.timeLeft, stageName: 'Marching Core Drill',
            ),
          ),

          if (therapy.status == SessionStatus.waiting)
            StageIntroOverlay(
              stage: 3,
              name: therapy.currentStageName,
              description: therapy.currentStageDescription,
              onStart: () { therapy.startCurrentStage(); stage.startGame(); },
            ),

          if (therapy.status == SessionStatus.stageDone)
            StageCompleteOverlay(
              stage: 3, score: state.reps, hasNext: false,
              onNext: () => context.read<TherapyProvider>().goToNextStage(),
            ),
        ],
      ),
    );
  }
}