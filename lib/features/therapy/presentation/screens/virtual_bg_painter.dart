import 'dart:math' as math;
import 'package:flutter/material.dart';

import '../../../../config/theme/colors/app_color.dart';

/// Virtual Background สำหรับแต่ละ stage
/// Python: make_virtual_bg(w, h, stage)
/// วาดด้วย CustomPainter แทน numpy/OpenCV

// ══════════════════════════════════════════════════════════════════
//  Stage 1 — Purple-blue gaming grid + floating orbs
// ══════════════════════════════════════════════════════════════════
class Stage1BgPainter extends CustomPainter {
  final double animTime;
  const Stage1BgPainter({required this.animTime});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // gradient background
    final bgPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF14071E), Color(0xFF281442)],
      ).createShader(Rect.fromLTWH(0, 0, w, h));
    canvas.drawRect(Rect.fromLTWH(0, 0, w, h), bgPaint);

    // grid lines — Python: random grid
    final gridPaint = Paint()
      ..color = const Color(0xFF32A0C8).withOpacity(0.12)
      ..strokeWidth = 1;

    for (double x = 0; x < w; x += w / 10) {
      canvas.drawLine(Offset(x, 0), Offset(x, h), gridPaint);
    }
    for (double y = 0; y < h; y += h / 10) {
      canvas.drawLine(Offset(0, y), Offset(w, y), gridPaint);
    }

    // floating orbs — Python: random circles with alpha
    final rng = math.Random(42);
    for (int i = 0; i < 18; i++) {
      final ox = rng.nextDouble() * w;
      final oy = rng.nextDouble() * h;
      final r  = 8.0 + rng.nextDouble() * 28;
      final pulse = math.sin(animTime * 0.8 + i * 0.7);
      final alpha = 0.04 + 0.03 * pulse;

      canvas.drawCircle(
        Offset(ox, oy), r,
        Paint()..color = const Color(0xFF64C8FF).withOpacity(alpha.clamp(0.0, 1.0)),
      );
    }

    // floor line — Python: floor highlight
    final floorPaint = Paint()
      ..color = AiAppColors.floorLine.withOpacity(0.5)
      ..strokeWidth = 2;
    canvas.drawLine(Offset(0, h * 0.88), Offset(w, h * 0.88), floorPaint);
  }

  @override
  bool shouldRepaint(Stage1BgPainter old) => old.animTime != animTime;
}

// ══════════════════════════════════════════════════════════════════
//  Stage 2 — Forest green + floating leaves
// ══════════════════════════════════════════════════════════════════
class Stage2BgPainter extends CustomPainter {
  final double animTime;
  const Stage2BgPainter({required this.animTime});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // gradient
    final bgPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFF0A1E05), Color(0xFF1E5014)],
      ).createShader(Rect.fromLTWH(0, 0, w, h));
    canvas.drawRect(Rect.fromLTWH(0, 0, w, h), bgPaint);

    // floating particles
    final rng = math.Random(99);
    for (int i = 0; i < 22; i++) {
      final ox  = rng.nextDouble() * w;
      final oy  = (rng.nextDouble() * h + animTime * 20 * (0.3 + rng.nextDouble())) % h;
      final r   = 3.0 + rng.nextDouble() * 8;
      final alpha = 0.05 + 0.04 * math.sin(animTime + i);
      canvas.drawCircle(
        Offset(ox, oy), r,
        Paint()..color = const Color(0xFF50DC78).withOpacity(alpha.clamp(0.0, 1.0)),
      );
    }

    // floor
    canvas.drawLine(
      Offset(0, h * 0.88), Offset(w, h * 0.88),
      Paint()..color = const Color(0xFF50DC78).withOpacity(0.4)..strokeWidth = 2,
    );
  }

  @override
  bool shouldRepaint(Stage2BgPainter old) => old.animTime != animTime;
}

// ══════════════════════════════════════════════════════════════════
//  Stage 3 — Dark purple + energy rings
// ══════════════════════════════════════════════════════════════════
class Stage3BgPainter extends CustomPainter {
  final double animTime;
  const Stage3BgPainter({required this.animTime});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // gradient
    final bgPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF0F1428), Color(0xFF3C2850)],
      ).createShader(Rect.fromLTWH(0, 0, w, h));
    canvas.drawRect(Rect.fromLTWH(0, 0, w, h), bgPaint);

    // energy rings — pulsing
    final cx = w / 2;
    final cy = h * 0.5;
    for (int i = 0; i < 4; i++) {
      final r     = 80.0 + i * 60 + 20 * math.sin(animTime * 1.2 + i * 0.8);
      final alpha = (0.06 - i * 0.01).clamp(0.0, 1.0);
      canvas.drawCircle(
        Offset(cx, cy), r,
        Paint()
          ..color = AiAppColors.purple.withOpacity(alpha)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2,
      );
    }

    // floating orbs
    final rng = math.Random(77);
    for (int i = 0; i < 15; i++) {
      final ox  = rng.nextDouble() * w;
      final oy  = rng.nextDouble() * h;
      final r   = 5.0 + rng.nextDouble() * 18;
      final alpha = 0.03 + 0.025 * math.sin(animTime * 1.1 + i);
      canvas.drawCircle(
        Offset(ox, oy), r,
        Paint()..color = AiAppColors.coral.withOpacity(alpha.clamp(0.0, 1.0)),
      );
    }

    // floor
    canvas.drawLine(
      Offset(0, h * 0.88), Offset(w, h * 0.88),
      Paint()..color = AiAppColors.purple.withOpacity(0.4)..strokeWidth = 2,
    );
  }

  @override
  bool shouldRepaint(Stage3BgPainter old) => old.animTime != animTime;
}

// ══════════════════════════════════════════════════════════════════
//  Widget wrapper — ใช้แทน Container สีดำ ข้างหลัง CameraPreview
// ══════════════════════════════════════════════════════════════════
class VirtualBgWidget extends StatelessWidget {
  final int stage;
  final double animTime;

  const VirtualBgWidget({
    super.key,
    required this.stage,
    required this.animTime,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: switch (stage) {
        1 => Stage1BgPainter(animTime: animTime),
        2 => Stage2BgPainter(animTime: animTime),
        3 => Stage3BgPainter(animTime: animTime),
        _ => Stage1BgPainter(animTime: animTime),
      },
      child: const SizedBox.expand(),
    );
  }
}