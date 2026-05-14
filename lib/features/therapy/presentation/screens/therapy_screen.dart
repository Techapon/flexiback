import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../config/theme/colors/app_color.dart';
import '../../domain/entities/therapy_session.dart';
import '../providers/therapy_provider.dart';
import '../providers/stage_provider.dart';
import 'stage1_screen.dart';
import 'stage2_screen.dart';
import 'stage3_screen.dart';
import '../widgets/hud_widget.dart';


// ══════════════════════════════════════════════════════════════════
//  Lobby Screen — กดปุ่มก่อนค่อยเริ่ม
// ══════════════════════════════════════════════════════════════════
class TherapyLobbyScreen extends StatelessWidget {
  const TherapyLobbyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0C0816),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'BackCare PT',
                style: TextStyle(
                  color: AiAppColors.teal,
                  fontSize: 42,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 3,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'กายภาพบำบัดปวดหลัง 3 ด่าน',
                style: TextStyle(color: Color(0xFFAFB9EB), fontSize: 16),
              ),
              const SizedBox(height: 64),

              // stage list
              ...List.generate(3, (i) {
                final names = TherapyProvider.stageNames;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 40),
                  child: Row(
                    children: [
                      Container(
                        width: 28, height: 28,
                        decoration: BoxDecoration(
                          color: AiAppColors.teal.withOpacity(0.2),
                          border: Border.all(color: AiAppColors.teal),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text('${i + 1}',
                            style: const TextStyle(color: AiAppColors.teal, fontWeight: FontWeight.bold)),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Text(names[i],
                        style: const TextStyle(color: Color(0xFFCDD2E6), fontSize: 15)),
                    ],
                  ),
                );
              }),

              const SizedBox(height: 64),

              // START button
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const TherapyScreen()),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 56, vertical: 18),
                  decoration: BoxDecoration(
                    border: Border.all(color: AiAppColors.teal, width: 2),
                    borderRadius: BorderRadius.circular(12),
                    color: AiAppColors.teal.withOpacity(0.15),
                  ),
                  child: const Text(
                    'START SESSION',
                    style: TextStyle(
                      color: AiAppColors.teal,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 3,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════════
//  TherapyScreen — Router หลักระหว่าง stage
// ══════════════════════════════════════════════════════════════════

class TherapyScreen extends StatelessWidget {
  const TherapyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TherapyProvider()),
        ChangeNotifierProvider(create: (_) => StageProvider()),
      ],
      child: const _TherapyBody(),
    );
  }
}

class _TherapyBody extends StatefulWidget {
  const _TherapyBody();

  @override
  State<_TherapyBody> createState() => _TherapyBodyState();
}

class _TherapyBodyState extends State<_TherapyBody> {
  int _lastStage = 0; // track เพื่อ force rebuild

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TherapyProvider>().startSession();
    });
  }

  @override
  Widget build(BuildContext context) {
    final therapy = context.watch<TherapyProvider>();

    // force rebuild camera เมื่อ stage เปลี่ยน
    if (therapy.currentStage != _lastStage) {
      _lastStage = therapy.currentStage;
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: switch (therapy.status) {
        SessionStatus.idle => const Center(child: CircularProgressIndicator()),

        SessionStatus.waiting ||
        SessionStatus.playing ||
        SessionStatus.stageDone =>
          // Key บังคับ Flutter dispose + recreate widget เมื่อ stage เปลี่ยน
          // ทำให้กล้องและ StageProvider reinit ใหม่ทุกครั้ง
          _buildStageScreen(therapy.currentStage,
              key: ValueKey('stage_${therapy.currentStage}')),

        SessionStatus.completed => Scaffold(
            backgroundColor: Colors.black,
            body: Stack(
              children: [
                FinalScreenOverlay(
                  scores: therapy.scores,
                  onExit: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),

        SessionStatus.quit => const SizedBox.shrink(),
      },
    );
  }

  Widget _buildStageScreen(int stage, {Key? key}) {
    return switch (stage) {
      1 => Stage1Screen(key: key),
      2 => Stage2Screen(key: key),
      3 => Stage3Screen(key: key),
      _ => const SizedBox.shrink(),
    };
  }
}