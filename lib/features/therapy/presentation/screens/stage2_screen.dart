import 'package:camera/camera.dart';
import 'package:flexiback/features/therapy/presentation/screens/virtual_bg_painter.dart';
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
import '../widgets/avatar_painter.dart';

/// Stage 2 — Lateral Side Reach
/// Python: run_stage2() — avatar + target circle + hand dots

class Stage2Screen extends StatefulWidget {
  const Stage2Screen({super.key});

  @override
  State<Stage2Screen> createState() => _Stage2ScreenState();
}

class _Stage2ScreenState extends State<Stage2Screen> {
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
    stage.setStage(2);
    stage.setImageSize(Size(
      _cam!.value.previewSize!.height,
      _cam!.value.previewSize!.width,
    ));

    // ผูก callback
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
      context.read<StageProvider>().processPose(poses.isNotEmpty ? poses.first : null);
    } finally {
      _busy = false;
    }
  }

  InputImage? _toInputImage(CameraImage img) {
    try {
      final format = InputImageFormatValue.fromRawValue(img.format.raw);
      if (format == null) return null;
      return InputImage.fromBytes(
        bytes: img.planes.first.bytes,
        metadata: InputImageMetadata(
          size: Size(img.width.toDouble(), img.height.toDouble()),
          rotation: InputImageRotation.rotation90deg,
          format: format,
          bytesPerRow: img.planes.first.bytesPerRow,
        ),
      );
    } catch (_) {
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
    final isLeft  = state.targetSide == DetectionSide.left;

    if (_cam == null || !_cam!.value.isInitialized) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          VirtualBgWidget(stage: 2, animTime: state.animTime),
          Opacity(opacity: 0.55, child: CameraPreview(_cam!)),
          if (stage.currentPose != null)
            CustomPaint(
              painter: AvatarPainter(
                pose: stage.currentPose!,
                imageSize: Size(
                  _cam!.value.previewSize!.height,
                  _cam!.value.previewSize!.width,
                ),
                animTime: state.animTime,
              ),
            ),
          CustomPaint(
            painter: Stage2TargetPainter(
              center: stage.targetCircleCenter(size.width, size.height),
              radius: stage.targetCircleRadius(),
              holdProgress: (state.holdFrames / StageState.holdThreshold).clamp(0.0, 1.0),
              isLeft: isLeft,
              animTime: state.animTime,
            ),
          ),
          Positioned(
            bottom: 52, left: 0, right: 0,
            child: Center(
              child: Text(
                'Touch circle  ${isLeft ? 'LEFT ←' : '→ RIGHT'}',
                style: const TextStyle(
                  color: AiAppColors.coral, fontSize: 22, fontWeight: FontWeight.bold,
                  shadows: [Shadow(color: Colors.black, offset: Offset(2,2), blurRadius: 4)],
                ),
              ),
            ),
          ),
          FlashOverlay(alpha: state.flashAlpha, color: AiAppColors.teal),
          FeedbackWidget(text: state.feedback, color: AiAppColors.teal),
          HowToPanel(lines: const [
            '1. Stand upright', '2. Reach arm sideways',
            '3. Touch the circle', '   with your hand/wrist',
            '4. Hold until bar fills', '5. Return & alternate',
            '   Stretches side back',
          ]),
          Positioned(
            top: 0, left: 0, right: 0,
            child: HudWidget(stage: 2, reps: state.reps, timeLeft: state.timeLeft, stageName: 'Lateral Side Reach'),
          ),
          if (therapy.status == SessionStatus.waiting)
            StageIntroOverlay(
              stage: 2, name: therapy.currentStageName,
              description: therapy.currentStageDescription,
              onStart: () { therapy.startCurrentStage(); stage.startGame(); },
            ),
          if (therapy.status == SessionStatus.stageDone)
            StageCompleteOverlay(
              stage: 2, score: state.reps, hasNext: true,
              onNext: () => context.read<TherapyProvider>().goToNextStage(),
            ),
        ],
      ),
    );
  }
}