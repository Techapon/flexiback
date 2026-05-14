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
//  Lobby Screen
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
                            style: const TextStyle(
                              color: AiAppColors.teal,
                              fontWeight: FontWeight.bold,
                            )),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Text(names[i],
                        style: const TextStyle(
                          color: Color(0xFFCDD2E6), fontSize: 15,
                        )),
                    ],
                  ),
                );
              }),
              const SizedBox(height: 64),
              GestureDetector(
                onTap: () {
                  // reset provider ก่อนเริ่ม session ใหม่
                  context.read<TherapyProvider>().reset();
                  context.read<StageProvider>().setStage(1);
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
//  TherapyScreen — Router หลัก ไม่สร้าง Provider ซ้ำ
// ══════════════════════════════════════════════════════════════════
class TherapyScreen extends StatefulWidget {
  const TherapyScreen({super.key});

  @override
  State<TherapyScreen> createState() => _TherapyScreenState();
}

class _TherapyScreenState extends State<TherapyScreen> {
  @override
  void initState() {
    super.initState();
    // startSession หลัง frame แรก render เสร็จ
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TherapyProvider>().startSession();
    });
  }

  @override
  Widget build(BuildContext context) {
    final therapy = context.watch<TherapyProvider>();

    return Scaffold(
      backgroundColor: Colors.black,
      body: switch (therapy.status) {
        SessionStatus.idle =>
          const Center(child: CircularProgressIndicator()),

        SessionStatus.waiting ||
        SessionStatus.playing ||
        SessionStatus.stageDone =>
          // ValueKey บังคับ dispose+recreate เมื่อ stage เปลี่ยน
          // ทำให้กล้อง reinit และ StageProvider.setStage() ถูกเรียกใหม่
          _buildStageScreen(
            therapy.currentStage,
            key: ValueKey('stage_${therapy.currentStage}'),
          ),

        SessionStatus.completed => Stack(
            children: [
              FinalScreenOverlay(
                scores: therapy.scores,
                onExit: () => Navigator.of(context).pop(),
              ),
            ],
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