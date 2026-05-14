import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

import '../../../../config/theme/colors/app_color.dart';

/// วาด body skeleton ทับกล้อง
/// เทียบกับ Python: draw_body_skeleton() — เส้น + dot เฉพาะร่างกาย ไม่มีใบหน้า
///
/// ใช้กับ Stage 1 และ Stage 3

class PosePainter extends CustomPainter {
  final Pose pose;
  final Size imageSize;
  final double animTime;

  PosePainter({
    required this.pose,
    required this.imageSize,
    required this.animTime,
  });

  // Python: BODY_CONNECTIONS = connections ที่ index > 10
  // ML Kit ไม่มี POSE_CONNECTIONS โดยตรง — define ด้วยตัวเอง
  static const _bodyConnections = [
    // torso
    [PoseLandmarkType.leftShoulder,  PoseLandmarkType.rightShoulder],
    [PoseLandmarkType.leftShoulder,  PoseLandmarkType.leftHip],
    [PoseLandmarkType.rightShoulder, PoseLandmarkType.rightHip],
    [PoseLandmarkType.leftHip,       PoseLandmarkType.rightHip],
    // arms
    [PoseLandmarkType.leftShoulder,  PoseLandmarkType.leftElbow],
    [PoseLandmarkType.leftElbow,     PoseLandmarkType.leftWrist],
    [PoseLandmarkType.rightShoulder, PoseLandmarkType.rightElbow],
    [PoseLandmarkType.rightElbow,    PoseLandmarkType.rightWrist],
    // legs
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
    final scaleX = size.width / imageSize.width;
    final scaleY = size.height / imageSize.height;

    Offset? _lm(PoseLandmarkType type, {double vis = 0.3}) {
      final lm = pose.landmarks[type];
      if (lm == null || lm.likelihood < vis) return null;
      return Offset(lm.x * imageSize.width * scaleX,
                    lm.y * imageSize.height * scaleY);
    }

    // ── Draw connections — Python: cv2.line (50,190,150) thick=3
    final linePaint = Paint()
      ..color = const Color(0xFF32BE96)   // BGR(50,190,150) → RGB
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.round;

    for (final conn in _bodyConnections) {
      final a = _lm(conn[0]);
      final b = _lm(conn[1]);
      if (a != null && b != null) {
        canvas.drawLine(a, b, linePaint);
      }
    }

    // ── Draw joints — Python: circle(80,220,180) r=7 + outline
    final dotPaint    = Paint()..color = const Color(0xFF50DCB4); // BGR(80,220,180)
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


// ── Zone constants (top-level) ────────────────────────────────────
/// Python: zu = int(h*0.32)
const double kCatZoneFraction = 0.32;

/// Python: zl = int(h*0.60)
const double kCowZoneFraction = 0.60;

/// Python: hip fallback = 0.52
const double kHipZoneFraction = 0.52;

/// วาด Zone lines สำหรับ Stage 1 (CAT / COW)
/// Python: cv2.line TEAL ที่ h*0.32, GOLD ที่ h*0.60
class Stage1ZonePainter extends CustomPainter {
  const Stage1ZonePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final tealPaint = Paint()
      ..color = AiAppColors.teal
      ..strokeWidth = 2.0;

    final goldPaint = Paint()
      ..color = AiAppColors.gold
      ..strokeWidth = 2.0;

    // CAT zone — TEAL line
    final catY = size.height * kCatZoneFraction;
    canvas.drawLine(Offset(0, catY), Offset(size.width, catY), tealPaint);

    // COW zone — GOLD line
    final cowY = size.height * kCowZoneFraction;
    canvas.drawLine(Offset(0, cowY), Offset(size.width, cowY), goldPaint);
  }

  @override
  bool shouldRepaint(Stage1ZonePainter old) => false;
}


/// วาด Hip Level line สำหรับ Stage 3
/// Python: cv2.line(out,(0,hip_ly),(w,hip_ly),PURPLE,2)
class HipLinePainter extends CustomPainter {
  final double hipY; // pixel position

  const HipLinePainter({required this.hipY});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AiAppColors.purple
      ..strokeWidth = 2.0;

    canvas.drawLine(Offset(0, hipY), Offset(size.width, hipY), paint);

    // Python: putText "HIP LEVEL"
    final tp = TextPainter(
      text: TextSpan(
        text: 'HIP LEVEL',
        style: TextStyle(
          color: AiAppColors.purple,
          fontSize: 12,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, Offset(size.width - tp.width - 12, hipY - 18));
  }

  @override
  bool shouldRepaint(HipLinePainter old) => old.hipY != hipY;
}


/// วาด Target Circle สำหรับ Stage 2
/// Python: cv2.circle pulsing radius + hold progress arc
class Stage2TargetPainter extends CustomPainter {
  final Offset center;
  final double radius;
  final double holdProgress; // 0.0 - 1.0
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

    // outer shadow
    canvas.drawCircle(
      center, radius + 5,
      Paint()..color = Colors.black.withOpacity(0.6),
    );

    // main circle
    canvas.drawCircle(
      center, radius,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 6.0,
    );

    // inner ring
    canvas.drawCircle(
      center, radius - 12,
      Paint()
        ..color = Colors.white.withOpacity(0.3)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0,
    );

    // Python: hold progress arc
    if (holdProgress > 0) {
      final arcPaint = Paint()
        ..color = const Color(0xFFFFDC3C)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 5.0
        ..strokeCap = StrokeCap.round;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius - 5),
        -math.pi / 2,
        2 * math.pi * holdProgress,
        false,
        arcPaint,
      );
    }

    // label
    final tp = TextPainter(
      text: TextSpan(
        text: isLeft ? '← REACH' : 'REACH →',
        style: TextStyle(
          color: color,
          fontSize: 13,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(
      canvas,
      Offset(center.dx - tp.width / 2, center.dy - radius - 24),
    );
  }

  @override
  bool shouldRepaint(Stage2TargetPainter old) =>
      old.center != center ||
      old.radius != radius ||
      old.holdProgress != holdProgress;
}


/// วาด Knee trail สำหรับ Stage 3
/// Python: trail เส้นทางเข่า deque maxlen=12
class KneeTrailPainter extends CustomPainter {
  final List<Offset> leftTrail;
  final List<Offset> rightTrail;

  const KneeTrailPainter({
    required this.leftTrail,
    required this.rightTrail,
  });

  @override
  void paint(Canvas canvas, Size size) {
    _drawTrail(canvas, leftTrail, AiAppColors.gold);
    _drawTrail(canvas, rightTrail, AiAppColors.coral);
  }

  void _drawTrail(Canvas canvas, List<Offset> trail, Color color) {
    if (trail.length < 2) return;
    for (int i = 1; i < trail.length; i++) {
      final alpha = i / trail.length;
      canvas.drawLine(
        trail[i - 1],
        trail[i],
        Paint()
          ..color = color.withOpacity(alpha)
          ..strokeWidth = math.max(1, alpha * 5)
          ..strokeCap = StrokeCap.round,
      );
    }
  }

  @override
  bool shouldRepaint(KneeTrailPainter old) =>
      old.leftTrail != leftTrail || old.rightTrail != rightTrail;
}