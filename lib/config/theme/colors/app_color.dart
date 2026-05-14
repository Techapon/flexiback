import 'dart:ui';
import 'package:flutter/material.dart';

class AppColor {
  static const base1 = Color(0xFFFFFFFF);
  static const base2 = Color(0xFFFCFCFC);
  static const base3 = Color(0xFFF8F8F8);

  static const main1 = Color(0xFFFF8F52);
  static const main2 = Color(0xFFFF6918);
  static const main3 = Color(0xFFF64F48);
  static const main4 = Color(0xFFEc3577);

  static const mainGradientColrs = [
    AppColor.main1,
    AppColor.main2,
    AppColor.main3,
    AppColor.main4,
  ];

  static const grey0   = Color(0xFFF0F0F0);
  static const grey1 = Color(0xFFE8E8E8);
  static const grey2 = Color(0xFFDBDBDB);
  static const grey3 = Color(0xFF999999);
  static const grey4 = Color(0xFF777777);

  static const black1 = Color(0xFF2A2A2A);

  static const blue1 = Color(0xFF188FFF);
  static const blue2 = Color.fromARGB(255, 31, 195, 255);
  static const blue3 = Color(0xFF575DED);
  static const blue4 = Color(0xFF3632E1);
  

  static const yellow1 = Color.fromARGB(255, 255, 223, 43);
  static const yellow2 = Color.fromARGB(255, 255, 202, 43);

  static const green1 = Color(0xFF10B981);

  static const red1 = Color(0xFFE11D20);

  static const cream1 = Color(0xFFFFCFBA);
  static const cream2 = Color(0xFFF8AD85);
  static const cream3 = Color(0xFFD47E5A);
  static const cream4 = Color(0xFF992E00);

  static const error = Color.fromARGB(255, 245, 102, 86);
  static const success = Color.fromARGB(255, 85, 236, 105);
}



class AiAppColors {
  AiAppColors._();

  // ── Avatar ──────────────────────────────────────────
  /// Python: AV_SKIN = (185, 215, 245) BGR → RGB (245,215,185)
  static const Color avSkin = Color(0xFFF5D7B9);

  /// Python: AV_HAIR = (35, 50, 70) BGR → RGB (70,50,35)
  static const Color avHair = Color(0xFF463223);

  /// Python: AV_SHIRT = (90, 170, 240) BGR → RGB (240,170,90)
  static const Color avShirt = Color(0xFFF0AA5A);

  /// Python: AV_PANTS = (70, 95, 160) BGR → RGB (160,95,70)
  static const Color avPants = Color(0xFFA05F46);

  /// Python: AV_SHOE = (35, 35, 55) BGR → RGB (55,35,35)
  static const Color avShoe = Color(0xFF372323);

  /// Python: AV_JOINT = (255, 210, 50) BGR → RGB (50,210,255)
  static const Color avJoint = Color(0xFF32D2FF);

  /// Python: AV_GLOW = (140, 230, 255) BGR → RGB (255,230,140)
  static const Color avGlow = Color(0xFFFFE68C);

  /// Python: AV_CHEEK = (150, 170, 230) BGR → RGB (230,170,150)
  static const Color avCheek = Color(0xFFE6AA96);

  // ── Game UI ─────────────────────────────────────────
  /// Python: TEAL = (30, 200, 160) BGR → RGB (160,200,30)
  static const Color teal = Color(0xFFA0C81E);

  /// Python: GOLD = (30, 190, 240) BGR → RGB (240,190,30)
  static const Color gold = Color(0xFFF0BE1E);

  /// Python: CORAL = (70, 90, 235) BGR → RGB (235,90,70)
  static const Color coral = Color(0xFFEB5A46);

  /// Python: PURPLE = (180, 100, 220) BGR → RGB (220,100,180)
  static const Color purple = Color(0xFFDC64B4);

  /// Python: C_GREY = (130, 130, 145) BGR → RGB (145,130,130)
  static const Color grey = Color(0xFF918282);

  /// Python: C_GOOD = (50, 195, 70) BGR → RGB (70,195,50)
  static const Color good = Color(0xFF46C332);

  /// Python: C_WARN = (30, 145, 245) BGR → RGB (245,145,30)
  static const Color warn = Color(0xFFF5911E);

  /// Python: C_BAD = (50, 50, 220) BGR → RGB (220,50,50)
  static const Color bad = Color(0xFFDC3232);

  // ── Outline / Shadow ────────────────────────────────
  /// Python: outline_col = (20,20,20)
  static const Color outline = Color(0xFF141414);

  // ── Stage backgrounds (dominant hues) ───────────────
  /// Stage 1: purple-blue gaming grid
  static const Color stageBg1Start = Color(0xFF14071E);
  static const Color stageBg1End   = Color(0xFF281442);

  /// Stage 2: green forest
  static const Color stageBg2Start = Color(0xFF0A1E05);
  static const Color stageBg2End   = Color(0xFF1E5014);

  /// Stage 3: warm orange-red
  static const Color stageBg3Start = Color(0xFF0F1428);
  static const Color stageBg3End   = Color(0xFF3C2850);

  /// Floor line color — Python: (80, 210, 180) BGR → RGB (180,210,80)
  static const Color floorLine = Color(0xFFB4D250);

  // ── Misc ─────────────────────────────────────────────
  static const Color black      = Color(0xFF000000);
  static const Color white      = Color(0xFFFFFFFF);
  static const Color transparent = Colors.transparent;

  // ── Helper: lerp สองสีตาม t ─────────────────────────
  static Color lerp(Color c1, Color c2, double t) {
    return Color.lerp(c1, c2, t.clamp(0.0, 1.0)) ?? c1;
  }
}