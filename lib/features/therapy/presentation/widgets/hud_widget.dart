import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../../config/theme/colors/app_color.dart';
import '../providers/therapy_provider.dart';

// ══════════════════════════════════════════════════════════════════
//  HUD Widget — top bar
//  Python: draw_hud(img, stage, reps, time_left, w, h, name)
// ══════════════════════════════════════════════════════════════════
class HudWidget extends StatelessWidget {
  final int stage;
  final int reps;
  final double timeLeft;
  final String stageName;

  const HudWidget({
    super.key,
    required this.stage,
    required this.reps,
    required this.timeLeft,
    required this.stageName,
  });

  static const double hudHeight = 90;
  static const int gameDuration = 60;

  @override
  Widget build(BuildContext context) {
    final tr = (timeLeft / gameDuration).clamp(0.0, 1.0);
    final timeColor = AiAppColors.lerp(AiAppColors.bad, AiAppColors.teal, tr);
    final timeStr = timeLeft.toInt().toString().padLeft(2, '0');

    return SizedBox(
      height: hudHeight,
      child: Stack(
        children: [
          // background — Python: addWeighted dark 0.78
          Container(
            color: const Color(0xFF14091F).withOpacity(0.88),
          ),

          // bottom teal line — Python: cv2.line TEAL at y=90
          Positioned(
            bottom: 0, left: 0, right: 0,
            child: Container(height: 2, color: AiAppColors.teal),
          ),

          // progress bar — Python: rectangle tr*w
          Positioned(
            bottom: 2, left: 0, right: 0,
            child: SizedBox(
              height: 3,
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: tr,
                child: Container(color: timeColor),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22),
            child: Row(
              children: [
                // LEFT — stage name
                Expanded(
                  flex: 3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'STAGE $stage/3',
                        style: const TextStyle(
                          color: AiAppColors.teal,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        stageName,
                        style: const TextStyle(
                          color: Color(0xFFD7DCF0),
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),

                // CENTER — timer
                Expanded(
                  flex: 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'TIME',
                        style: TextStyle(
                          color: AiAppColors.grey,
                          fontSize: 10,
                          letterSpacing: 2,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            timeStr,
                            style: TextStyle(
                              color: timeColor,
                              fontSize: 38,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 2,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Text(
                            'SEC',
                            style: TextStyle(
                              color: AiAppColors.grey,
                              fontSize: 10,
                              letterSpacing: 1,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // RIGHT — reps
                Expanded(
                  flex: 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text(
                        'REPS',
                        style: TextStyle(
                          color: AiAppColors.grey,
                          fontSize: 10,
                          letterSpacing: 2,
                        ),
                      ),
                      Text(
                        '$reps',
                        style: const TextStyle(
                          color: AiAppColors.gold,
                          fontSize: 38,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════
//  Feedback Widget — bottom center text
//  Python: show_feedback(img, text, color, w, h)
// ══════════════════════════════════════════════════════════════════
class FeedbackWidget extends StatelessWidget {
  final String text;
  final Color color;

  const FeedbackWidget({
    super.key,
    required this.text,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    if (text.isEmpty) return const SizedBox.shrink();
    return Positioned(
      bottom: 52,
      left: 0,
      right: 0,
      child: Center(
        child: Stack(
          children: [
            // shadow — Python: putText offset (+2,+2) black thick=4
            Text(
              text,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                shadows: [Shadow(offset: Offset(2, 2), blurRadius: 0)],
              ),
            ),
            Text(
              text,
              style: TextStyle(
                color: color,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════
//  Flash overlay — Python: flash effect cv2.addWeighted
// ══════════════════════════════════════════════════════════════════
class FlashOverlay extends StatelessWidget {
  final double alpha;
  final Color color;

  const FlashOverlay({
    super.key,
    required this.alpha,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    if (alpha <= 0) return const SizedBox.shrink();
    return Positioned.fill(
      child: IgnorePointer(
        child: Container(
          color: color.withOpacity(alpha.clamp(0.0, 0.5)),
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════
//  HowTo Panel — right side panel
//  Python: draw_howto(img, lines, w, title)
// ══════════════════════════════════════════════════════════════════
class HowToPanel extends StatelessWidget {
  final List<String> lines;
  final String title;

  const HowToPanel({
    super.key,
    required this.lines,
    this.title = 'HOW TO PLAY',
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: HudWidget.hudHeight + 8,
      right: 14,
      child: Container(
        width: 220,
        decoration: BoxDecoration(
          color: const Color(0xFF19102C).withOpacity(0.88),
          border: Border.all(color: AiAppColors.teal, width: 1),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: const BoxDecoration(
                color: Color(0xFF122438),
                borderRadius: BorderRadius.vertical(top: Radius.circular(5)),
              ),
              child: Row(
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: AiAppColors.teal,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(color: AiAppColors.teal, height: 1),
            // steps
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: lines.map((line) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(
                    line,
                    style: const TextStyle(
                      color: Color(0xFFCDD2E6),
                      fontSize: 11,
                    ),
                  ),
                )).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════
//  Stage Intro Overlay — Python: screen_overlay / wait_n
// ══════════════════════════════════════════════════════════════════
class StageIntroOverlay extends StatelessWidget {
  final int stage;
  final String name;
  final List<String> description;
  final VoidCallback onStart;

  const StageIntroOverlay({
    super.key,
    required this.stage,
    required this.name,
    required this.description,
    required this.onStart,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Container(
        color: const Color(0xFF0C0816).withOpacity(0.85),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // title — Python: HERSHEY_DUPLEX 2.3 TEAL
            Text(
              'STAGE $stage',
              style: const TextStyle(
                color: AiAppColors.teal,
                fontSize: 42,
                fontWeight: FontWeight.w900,
                letterSpacing: 4,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              name,
              style: const TextStyle(
                color: Color(0xFFD7DCF0),
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 32),
            // description lines
            ...description.map((line) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Text(
                line,
                style: const TextStyle(
                  color: Color(0xFFAFB9EB),
                  fontSize: 15,
                ),
                textAlign: TextAlign.center,
              ),
            )),
            const SizedBox(height: 48),
            // hint — Python: GOLD "Press N to start"
            GestureDetector(
              onTap: onStart,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                decoration: BoxDecoration(
                  border: Border.all(color: AiAppColors.gold, width: 2),
                  borderRadius: BorderRadius.circular(8),
                  color: AiAppColors.gold.withOpacity(0.12),
                ),
                child: const Text(
                  'TAP TO START',
                  style: TextStyle(
                    color: AiAppColors.gold,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 3,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════
//  Stage Complete Overlay — Python: complete_screen
// ══════════════════════════════════════════════════════════════════
class StageCompleteOverlay extends StatelessWidget {
  final int stage;
  final int score;
  final bool hasNext;
  final VoidCallback onNext;

  const StageCompleteOverlay({
    super.key,
    required this.stage,
    required this.score,
    required this.hasNext,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    final msg = TherapyProvider.scoreMessage(score);
    final msgColor = score >= 12
        ? AiAppColors.teal
        : score >= 7
            ? AiAppColors.good
            : AiAppColors.warn;

    return Positioned.fill(
      child: Container(
        color: const Color(0xFF0A0712).withOpacity(0.88),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'STAGE $stage COMPLETE!',
              style: const TextStyle(
                color: AiAppColors.teal,
                fontSize: 36,
                fontWeight: FontWeight.w900,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Repetitions: $score',
              style: const TextStyle(
                color: AiAppColors.gold,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              msg,
              style: TextStyle(
                color: msgColor,
                fontSize: 17,
              ),
            ),
            const SizedBox(height: 40),
            GestureDetector(
              onTap: onNext,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 14),
                decoration: BoxDecoration(
                  border: Border.all(color: AiAppColors.teal, width: 2),
                  borderRadius: BorderRadius.circular(8),
                  color: AiAppColors.teal.withOpacity(0.12),
                ),
                child: Text(
                  hasNext ? 'NEXT STAGE →' : 'FINISH',
                  style: const TextStyle(
                    color: Color(0xFFC8CEDE),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════
//  Final Screen — Python: final_screen
// ══════════════════════════════════════════════════════════════════
class FinalScreenOverlay extends StatelessWidget {
  final List<int> scores;
  final VoidCallback onExit;

  const FinalScreenOverlay({
    super.key,
    required this.scores,
    required this.onExit,
  });

  @override
  Widget build(BuildContext context) {
    final names = TherapyProvider.stageNames;
    final total = scores.fold(0, (s, r) => s + r);

    return Positioned.fill(
      child: Container(
        color: const Color(0xFF08050F).withOpacity(0.90),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'SESSION COMPLETE!',
              style: TextStyle(
                color: AiAppColors.gold,
                fontSize: 38,
                fontWeight: FontWeight.w900,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 32),

            // stage results
            ...List.generate(scores.length, (i) {
              final sc = scores[i];
              final col = sc >= 10
                  ? AiAppColors.teal
                  : sc >= 6
                      ? AiAppColors.gold
                      : AiAppColors.warn;
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 40),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Stage ${i + 1} — ${names[i]}',
                        style: const TextStyle(
                          color: Color(0xFF9BA0C8),
                          fontSize: 14,
                        ),
                      ),
                    ),
                    Text(
                      '$sc reps',
                      style: TextStyle(
                        color: col,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              );
            }),

            const Divider(color: Color(0xFF3C2864), height: 32, indent: 40, endIndent: 40),

            Text(
              'Total: $total reps',
              style: const TextStyle(
                color: AiAppColors.teal,
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Practice daily for best results!',
              style: TextStyle(color: Color(0xFFB2B6DC), fontSize: 14),
            ),
            const SizedBox(height: 40),
            GestureDetector(
              onTap: onExit,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 14),
                decoration: BoxDecoration(
                  border: Border.all(color: AiAppColors.grey, width: 1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'EXIT',
                  style: TextStyle(
                    color: AiAppColors.grey,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 3,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}