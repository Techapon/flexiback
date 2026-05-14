import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

import '../../../../config/theme/colors/app_color.dart';
import '../../../../core/utils/pose_utils.dart';

/// วาด Cartoon Avatar ทับ pose landmarks
/// เทียบกับ Python: draw_avatar()
/// ใช้กับ Stage 2 (Lateral Side Reach)

class AvatarPainter extends CustomPainter {
  final Pose pose;
  final Size imageSize;
  final double animTime; // Python: t

  AvatarPainter({
    required this.pose,
    required this.imageSize,
    required this.animTime,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final scaleX = size.width / imageSize.width;
    final scaleY = size.height / imageSize.height;

    // helper — แปลง landmark เป็น Offset บนหน้าจอ
    Offset? lp(PoseLandmarkType type, {double vis = 0.25}) {
      final lm = pose.landmarks[type];
      if (lm == null || lm.likelihood < vis) return null;
      return Offset(lm.x * imageSize.width * scaleX,
                    lm.y * imageSize.height * scaleY);
    }

    final nose  = lp(PoseLandmarkType.nose);
    final lSh   = lp(PoseLandmarkType.leftShoulder);
    final rSh   = lp(PoseLandmarkType.rightShoulder);
    final lEl   = lp(PoseLandmarkType.leftElbow);
    final rEl   = lp(PoseLandmarkType.rightElbow);
    final lWr   = lp(PoseLandmarkType.leftWrist);
    final rWr   = lp(PoseLandmarkType.rightWrist);
    final lHip  = lp(PoseLandmarkType.leftHip);
    final rHip  = lp(PoseLandmarkType.rightHip);
    final lKn   = lp(PoseLandmarkType.leftKnee);
    final rKn   = lp(PoseLandmarkType.rightKnee);
    final lAn   = lp(PoseLandmarkType.leftAnkle);
    final rAn   = lp(PoseLandmarkType.rightAnkle);

    // Python: sc = max(0.5, dist2(l_sh,r_sh)/100.0)
    final sc = PoseUtils.shoulderScale(lSh, rSh);

    // ── TORSO ──────────────────────────────────────
    if (lSh != null && rSh != null && lHip != null && rHip != null) {
      final torsoPath = Path()
        ..moveTo(lSh.dx, lSh.dy)
        ..lineTo(rSh.dx, rSh.dy)
        ..lineTo(rHip.dx, rHip.dy)
        ..lineTo(lHip.dx, lHip.dy)
        ..close();

      canvas.drawPath(torsoPath, Paint()..color = AiAppColors.avShirt);
      canvas.drawPath(
        torsoPath,
        Paint()
          ..color = const Color(0xFF195AB4)
          ..style = PaintingStyle.stroke
          ..strokeWidth = math.max(2, 3 * sc),
      );

      // center line
      final midSh  = PoseUtils.midpoint(lSh, rSh);
      final midHip = PoseUtils.midpoint(lHip, rHip);
      canvas.drawLine(midSh, midHip,
        Paint()
          ..color = const Color(0xFF3282D2)
          ..strokeWidth = math.max(1, 2 * sc),
      );
    }

    // ── LEGS ───────────────────────────────────────
    final lt = math.max(8.0, 18.0 * sc);
    _drawThickLimb(canvas, lHip, lKn, AiAppColors.avPants, lt);
    _drawThickLimb(canvas, rHip, rKn, AiAppColors.avPants, lt);
    _drawThickLimb(canvas, lKn,  lAn, AiAppColors.avPants, math.max(6.0, 13.0 * sc));
    _drawThickLimb(canvas, rKn,  rAn, AiAppColors.avPants, math.max(6.0, 13.0 * sc));

    // ── SHOES ──────────────────────────────────────
    final sr = math.max(7.0, 13.0 * sc);
    for (final pt in [lAn, rAn]) {
      if (pt != null) {
        canvas.drawOval(
          Rect.fromCenter(center: pt, width: (sr + 7) * 2, height: (sr / 2 + 3) * 2),
          Paint()..color = Colors.black,
        );
        canvas.drawOval(
          Rect.fromCenter(center: pt, width: (sr + 5) * 2, height: (sr / 2 + 1) * 2),
          Paint()..color = AiAppColors.avShoe,
        );
      }
    }

    // ── ARMS ───────────────────────────────────────
    final at = math.max(6.0, 13.0 * sc);
    _drawThickLimb(canvas, lSh, lEl, AiAppColors.avShirt, at);
    _drawThickLimb(canvas, rSh, rEl, AiAppColors.avShirt, at);
    _drawThickLimb(canvas, lEl, lWr, AiAppColors.avSkin, math.max(5.0, 10.0 * sc));
    _drawThickLimb(canvas, rEl, rWr, AiAppColors.avSkin, math.max(5.0, 10.0 * sc));

    // ── HANDS ──────────────────────────────────────
    final hr = math.max(7.0, 11.0 * sc);
    for (final pt in [lWr, rWr]) {
      if (pt != null) {
        canvas.drawCircle(pt, hr + 2, Paint()..color = Colors.black);
        canvas.drawCircle(pt, hr, Paint()..color = AiAppColors.avSkin);
        // fingers — Python: angles [270,310,350,30,70]
        for (final ang in [270.0, 310.0, 350.0, 30.0, 70.0]) {
          final rad = ang * math.pi / 180;
          final fp = Offset(
            pt.dx + (hr + 5) * math.cos(rad),
            pt.dy + (hr + 5) * math.sin(rad),
          );
          canvas.drawCircle(
            fp,
            math.max(3.0, 4.0 * sc),
            Paint()..color = AiAppColors.avSkin,
          );
        }
      }
    }

    // ── JOINTS (glowing) ───────────────────────────
    final jr  = math.max(5.0, 8.0 * sc);
    final glr = jr + 3 * (math.sin(animTime * 3)).abs(); // Python: glr = jr+int(3*abs(sin(t*3)))

    for (final pt in [lSh, rSh, lEl, rEl, lHip, rHip, lKn, rKn]) {
      if (pt != null) {
        // glow — Python: addWeighted 0.35
        canvas.drawCircle(
          pt, glr + 4,
          Paint()..color = AiAppColors.avGlow.withOpacity(0.35),
        );
        canvas.drawCircle(pt, jr, Paint()..color = AiAppColors.avJoint);
        canvas.drawCircle(
          pt, jr,
          Paint()
            ..color = const Color(0xFF141414)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1.0,
        );
      }
    }

    // ── HEAD ───────────────────────────────────────
    if (nose != null) {
      final hr2 = math.max(22.0, 34.0 * sc);

      // shadow
      canvas.drawCircle(
        Offset(nose.dx + 3, nose.dy + 4),
        hr2 + 2,
        Paint()..color = Colors.black,
      );
      // head base
      canvas.drawCircle(nose, hr2 + 2, Paint()..color = const Color(0xFF0F0F0F));
      canvas.drawCircle(nose, hr2, Paint()..color = AiAppColors.avSkin);

      // hair — Python: fillPoly hp
      final hairPath = Path()
        ..moveTo(nose.dx - hr2 * 0.9, nose.dy - hr2 * 0.3)
        ..lineTo(nose.dx - hr2 * 0.5, nose.dy - hr2 - 6 * sc)
        ..lineTo(nose.dx,              nose.dy - hr2 - 10 * sc)
        ..lineTo(nose.dx + hr2 * 0.5, nose.dy - hr2 - 6 * sc)
        ..lineTo(nose.dx + hr2 * 0.9, nose.dy - hr2 * 0.3)
        ..close();
      canvas.drawPath(hairPath, Paint()..color = AiAppColors.avHair);

      // cheeks
      final ck = math.max(6.0, 9.0 * sc);
      canvas.drawCircle(
        Offset(nose.dx - hr2 * 0.48, nose.dy + hr2 * 0.2),
        ck, Paint()..color = AiAppColors.avCheek,
      );
      canvas.drawCircle(
        Offset(nose.dx + hr2 * 0.48, nose.dy + hr2 * 0.2),
        ck, Paint()..color = AiAppColors.avCheek,
      );

      // eyes — Python: blink = abs(sin(t*0.9)) > 0.97
      final er    = math.max(5.0, 7.0 * sc);
      final blink = (math.sin(animTime * 0.9)).abs() > 0.97;
      for (final eye in [
        Offset(nose.dx - hr2 * 0.36, nose.dy - hr2 * 0.1),
        Offset(nose.dx + hr2 * 0.36, nose.dy - hr2 * 0.1),
      ]) {
        canvas.drawCircle(eye, er + 1, Paint()..color = const Color(0xFF0F0F0F));
        if (blink) {
          canvas.drawLine(
            Offset(eye.dx - er, eye.dy),
            Offset(eye.dx + er, eye.dy),
            Paint()..color = const Color(0xFF0F0F0F)..strokeWidth = 2,
          );
        } else {
          canvas.drawCircle(eye, er, Paint()..color = Colors.white);
          canvas.drawCircle(eye, math.max(3.0, 5.0 * sc), Paint()..color = const Color(0xFF0F0F0F));
          // highlight dot
          canvas.drawCircle(
            Offset(eye.dx + 2, eye.dy - 2),
            math.max(1.0, 2.0 * sc),
            Paint()..color = Colors.white,
          );
        }
      }

      // smile
      final smilePath = Path();
      final sw2 = hr2 * 0.38;
      final smileRect = Rect.fromCenter(
        center: Offset(nose.dx, nose.dy + hr2 * 0.4),
        width: sw2 * 2,
        height: sw2 * 0.9,
      );
      smilePath.addArc(smileRect, 0, math.pi);
      canvas.drawPath(
        smilePath,
        Paint()
          ..color = const Color(0xFF0F0F0F)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.0,
      );

      // eyebrows
      for (final side in [-1.0, 1.0]) {
        final bx1 = nose.dx + side * hr2 * 0.12;
        final bx2 = nose.dx + side * hr2 * 0.52;
        final by  = nose.dy - hr2 * 0.28;
        canvas.drawLine(
          Offset(bx1, by),
          Offset(bx2, by - 2 * sc),
          Paint()
            ..color = AiAppColors.avHair
            ..strokeWidth = math.max(2.0, 3.0 * sc)
            ..strokeCap = StrokeCap.round,
        );
      }

      // sparkles — Python: 4 rotating stars
      for (int i = 0; i < 4; i++) {
        final ang = animTime * 55 * math.pi / 180 + i * math.pi / 2;
        final sx  = nose.dx + (hr2 + 18) * math.cos(ang);
        final sy  = nose.dy + (hr2 + 18) * math.sin(ang);
        final sSize = 4 + 2 * math.sin(animTime * 4 + i);
        _drawStar(canvas, Offset(sx, sy), sSize, const Color(0xFFFFE13C));
      }
    }
  }

  // ── Helpers ─────────────────────────────────────

  /// Python: draw_thick_limb — วาด limb มี outline + fill color
  void _drawThickLimb(Canvas canvas, Offset? p1, Offset? p2, Color color, double thick) {
    if (p1 == null || p2 == null) return;
    canvas.drawLine(p1, p2,
      Paint()
        ..color = const Color(0xFF141414)
        ..strokeWidth = thick + 5
        ..strokeCap = StrokeCap.round,
    );
    canvas.drawLine(p1, p2,
      Paint()
        ..color = color
        ..strokeWidth = thick
        ..strokeCap = StrokeCap.round,
    );
  }

  /// Python: draw_star — 5 เส้นจากจุดกลาง
  void _drawStar(Canvas canvas, Offset center, double size, Color color) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;
    for (int i = 0; i < 5; i++) {
      final angle = i * 72 * math.pi / 180 - math.pi / 2;
      canvas.drawLine(
        center,
        Offset(center.dx + size * math.cos(angle),
               center.dy + size * math.sin(angle)),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(AvatarPainter old) =>
      old.pose != pose || old.animTime != animTime;
}