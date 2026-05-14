import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

/// Utility functions แปลงจาก Python helpers ใน BackCare PT
/// lerp, midpt, dist2, lmp และ geometry helpers

class PoseUtils {
  PoseUtils._();

  // ── Math helpers ────────────────────────────────────

  /// Python: lerp(c1, c2, t)
  /// interpolate ระหว่างสองค่า (ใช้กับ double)
  static double lerp(double a, double b, double t) {
    final clamped = t.clamp(0.0, 1.0);
    return a + (b - a) * clamped;
  }

  /// Python: midpt(a, b)
  /// หาจุดกึ่งกลางระหว่าง 2 Offset
  static Offset midpoint(Offset a, Offset b) {
    return Offset((a.dx + b.dx) / 2, (a.dy + b.dy) / 2);
  }

  /// Python: dist2(a, b) — ใช้ hypot
  /// ระยะห่างระหว่างสอง Offset (pixel)
  static double distance(Offset a, Offset b) {
    return math.sqrt(
      math.pow(a.dx - b.dx, 2) + math.pow(a.dy - b.dy, 2),
    );
  }

  /// คำนวณมุมเป็น degree ระหว่าง 3 จุด (a-b-c)
  /// ใช้สำหรับวัดมุม joint เช่น ข้อศอก เข่า
  static double angleDeg(Offset a, Offset b, Offset c) {
    final ab = Offset(a.dx - b.dx, a.dy - b.dy);
    final cb = Offset(c.dx - b.dx, c.dy - b.dy);
    final dot = ab.dx * cb.dx + ab.dy * cb.dy;
    final cross = ab.dx * cb.dy - ab.dy * cb.dx;
    return math.atan2(cross.abs(), dot) * 180 / math.pi;
  }

  // ── Landmark helpers ────────────────────────────────

  /// Python: lmp(lms, idx, w, h, vis=0.25)
  /// แปลง PoseLandmark เป็น Offset บนหน้าจอ
  /// คืน null ถ้า visibility ต่ำกว่า threshold
  static Offset? landmarkToOffset(
    PoseLandmark landmark,
    double imageWidth,
    double imageHeight, {
    double visThreshold = 0.25,
  }) {
    if (landmark.likelihood < visThreshold) return null;
    return Offset(
      landmark.x * imageWidth,
      landmark.y * imageHeight,
    );
  }

  /// ดึง landmark หลายจุดพร้อมกัน คืน Map<PoseLandmarkType, Offset?>
  static Map<PoseLandmarkType, Offset?> extractLandmarks(
    Pose pose,
    List<PoseLandmarkType> types,
    double imageWidth,
    double imageHeight, {
    double visThreshold = 0.25,
  }) {
    return {
      for (final type in types)
        type: pose.landmarks[type] != null
            ? landmarkToOffset(
                pose.landmarks[type]!,
                imageWidth,
                imageHeight,
                visThreshold: visThreshold,
              )
            : null,
    };
  }

  // ── Scale helper ────────────────────────────────────

  /// Python: sc = max(0.5, dist2(l_sh, r_sh) / 100.0)
  /// คำนวณ scale factor จากระยะไหล่ทั้งสองข้าง
  /// ใช้ scale ขนาด avatar และ limb thickness
  static double shoulderScale(Offset? leftShoulder, Offset? rightShoulder) {
    if (leftShoulder == null || rightShoulder == null) return 0.8;
    return math.max(0.5, distance(leftShoulder, rightShoulder) / 100.0);
  }

  // ── Position checks ─────────────────────────────────

  /// ตรวจว่า point อยู่เหนือ threshold y หรือไม่
  /// ใช้ใน Stage 1 (Cat-Cow) และ Stage 3 (knee lift)
  static bool isAbove(Offset? point, double thresholdY) {
    if (point == null) return false;
    return point.dy < thresholdY;
  }

  /// ตรวจว่า point อยู่ต่ำกว่า threshold y หรือไม่
  static bool isBelow(Offset? point, double thresholdY) {
    if (point == null) return false;
    return point.dy > thresholdY;
  }

  /// ตรวจว่า point อยู่ในวงกลมเป้าหมายหรือไม่
  /// ใช้ใน Stage 2 (Lateral Side Reach)
  static bool isInsideCircle(Offset? point, Offset center, double radius) {
    if (point == null) return false;
    return distance(point, center) <= radius;
  }

  // ── Star points ──────────────────────────────────────

  /// Python: draw_star — คำนวณ 5 จุดของดาว
  /// ใช้ใน CustomPainter วาด star effect
  static List<Offset> starPoints(Offset center, double size) {
    return List.generate(5, (i) {
      final angle = math.pi * i * 72 / 180 - math.pi / 2;
      return Offset(
        center.dx + size * math.cos(angle),
        center.dy + size * math.sin(angle),
      );
    });
  }

  // ── Game constants ───────────────────────────────────

  /// Python: GAME_DURATION = 60
  static const int gameDurationSeconds = 60;
}