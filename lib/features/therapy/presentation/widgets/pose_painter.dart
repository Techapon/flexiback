import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

import '../../../../config/theme/colors/app_color.dart';

/// วาด body skeleton ทับกล้อง
/// ML Kit คืน landmark.x / landmark.y เป็น normalized 0-1
/// ดังนั้น Offset = (lm.x * canvasWidth, lm.y * canvasHeight) ได้เลย
/// ไม่ต้องใช้ imageSize อีกต่อไป

class PosePainter extends CustomPainter {
  final Pose pose;
  final Size imageSize; // เก็บไว้เพื่อ compatibility แต่ไม่ใช้แล้ว
  final double animTime;

  PosePainter({
    required this.pose,
    required this.imageSize,
    required this.animTime,
  });

  static const _bodyConnections = [
    [PoseLandmarkType.leftShoulder,  PoseLandmarkType.rightShoulder],
    [PoseLandmarkType.leftShoulder,  PoseLandmarkType.leftHip],
    [PoseLandmarkType.rightShoulder, PoseLandmarkType.rightHip],
    [PoseLandmarkType.leftHip,       PoseLandmarkType.rightHip],
    [PoseLandmarkType.leftShoulder,  PoseLandmarkType.leftElbow],
    [PoseLandmarkType.leftElbow,     PoseLandmarkType.leftWrist],
    [PoseLandmarkType.rightShoulder, PoseLandmarkType.rightElbow],
    [PoseLandmarkType.rightElbow,    PoseLandmarkType.rightWrist],
    [PoseLandmarkType.leftHip,       PoseLandmarkType.leftKnee],
    [PoseLandmarkType.leftKnee,      PoseLandmarkType.leftAnkle],
    [PoseLandmarkType.rightHip,      PoseLandmarkType.rightKnee],
    [PoseLandmarkType.rightKnee,     PoseLandmarkType.rightAnkle],
  ];

  static const _bodyLandmarks = [
    PoseLandmarkType.leftShoulder,
    PoseLandmarkType.rightShoulder,
    PoseLandmarkType.leftElbow,
    PoseLandmarkType.rightElbow,
    PoseLandmarkType.leftWrist,
    PoseLandmarkType.rightWrist,
    PoseLandmarkType.leftHip,
    PoseLandmarkType.rightHip,
    PoseLandmarkType.leftKnee,
    PoseLandmarkType.rightKnee,
    PoseLandmarkType.leftAnkle,
    PoseLandmarkType.rightAnkle,
  ];

  @override
  void paint(Canvas canvas, Size size) {
    // normalized → canvas pixels โดยตรง
    Offset? _lm(PoseLandmarkType type, {double vis = 0.3}) {
      final lm = pose.landmarks[type];
      if (lm == null || lm.likelihood < vis) return null;
      return Offset(lm.x * size.width, lm.y * size.height);
    }

    final linePaint = Paint()
      ..color = const Color(0xFF32BE96)
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.round;

    for (final conn in _bodyConnections) {
      final a = _lm(conn[0]);
      final b = _lm(conn[1]);
      if (a != null && b != null) canvas.drawLine(a, b, linePaint);
    }

    final dotPaint = Paint()..color = const Color(0xFF50DCB4);
    final outlinePaint = Paint()
      ..color = AiAppColors.outline
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    for (final type in _bodyLandmarks) {
      final pt = _lm(type);
      if (pt != null) {
        canvas.drawCircle(pt, 7, dotPaint);
        canvas.drawCircle(pt, 7, outlinePaint);
      }
    }
  }

  @override
  bool shouldRepaint(PosePainter old) =>
      old.pose != pose || old.animTime != animTime;
}


const double kCatZoneFraction = 0.32;
const double kCowZoneFraction = 0.60;
const double kHipZoneFraction = 0.52;

class Stage1ZonePainter extends CustomPainter {
  const Stage1ZonePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final tealPaint = Paint()..color = AiAppColors.teal..strokeWidth = 2.0;
    final goldPaint = Paint()..color = AiAppColors.gold..strokeWidth = 2.0;

    canvas.drawLine(Offset(0, size.height * kCatZoneFraction),
        Offset(size.width, size.height * kCatZoneFraction), tealPaint);
    canvas.drawLine(Offset(0, size.height * kCowZoneFraction),
        Offset(size.width, size.height * kCowZoneFraction), goldPaint);
  }

  @override
  bool shouldRepaint(Stage1ZonePainter old) => false;
}


class HipLinePainter extends CustomPainter {
  final double hipY;
  const HipLinePainter({required this.hipY});

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawLine(
      Offset(0, hipY), Offset(size.width, hipY),
      Paint()..color = AiAppColors.purple..strokeWidth = 2.0,
    );
    final tp = TextPainter(
      text: TextSpan(
        text: 'HIP LEVEL',
        style: TextStyle(
          color: AiAppColors.purple, fontSize: 12,
          fontWeight: FontWeight.bold, letterSpacing: 1.2,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, Offset(size.width - tp.width - 12, hipY - 18));
  }

  @override
  bool shouldRepaint(HipLinePainter old) => old.hipY != hipY;
}


class Stage2TargetPainter extends CustomPainter {
  final Offset center;
  final double radius;
  final double holdProgress;
  final bool isLeft;
  final double animTime;

  const Stage2TargetPainter({
    required this.center,
    required this.radius,
    required this.holdProgress,
    required this.isLeft,
    required this.animTime,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final color = isLeft ? AiAppColors.gold : AiAppColors.coral;

    canvas.drawCircle(center, radius + 5,
        Paint()..color = Colors.black.withOpacity(0.6));
    canvas.drawCircle(center, radius,
        Paint()..color = color..style = PaintingStyle.stroke..strokeWidth = 6.0);
    canvas.drawCircle(center, radius - 12,
        Paint()..color = Colors.white.withOpacity(0.3)
          ..style = PaintingStyle.stroke..strokeWidth = 1.0);

    if (holdProgress > 0) {
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius - 5),
        -math.pi / 2,
        2 * math.pi * holdProgress,
        false,
        Paint()..color = const Color(0xFFFFDC3C)
          ..style = PaintingStyle.stroke..strokeWidth = 5.0
          ..strokeCap = StrokeCap.round,
      );
    }

    final tp = TextPainter(
      text: TextSpan(
        text: isLeft ? '← REACH' : 'REACH →',
        style: TextStyle(color: color, fontSize: 13, fontWeight: FontWeight.bold),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, Offset(center.dx - tp.width / 2, center.dy - radius - 24));
  }

  @override
  bool shouldRepaint(Stage2TargetPainter old) =>
      old.center != center || old.radius != radius || old.holdProgress != holdProgress;
}


class KneeTrailPainter extends CustomPainter {
  final List<Offset> leftTrail;
  final List<Offset> rightTrail;

  const KneeTrailPainter({required this.leftTrail, required this.rightTrail});

  @override
  void paint(Canvas canvas, Size size) {
    _drawTrail(canvas, leftTrail, AiAppColors.gold);
    _drawTrail(canvas, rightTrail, AiAppColors.coral);
  }

  void _drawTrail(Canvas canvas, List<Offset> trail, Color color) {
    if (trail.length < 2) return;
    for (int i = 1; i < trail.length; i++) {
      final alpha = i / trail.length;
      canvas.drawLine(trail[i - 1], trail[i],
        Paint()..color = color.withOpacity(alpha)
          ..strokeWidth = math.max(1, alpha * 5)
          ..strokeCap = StrokeCap.round);
    }
  }

  @override
  bool shouldRepaint(KneeTrailPainter old) =>
      old.leftTrail != leftTrail || old.rightTrail != rightTrail;
}