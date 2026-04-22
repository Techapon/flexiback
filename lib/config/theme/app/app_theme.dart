import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../colors/app_color.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.light(
      primary: AppColor.main2
    ),

    scaffoldBackgroundColor: AppColor.base1,

    appBarTheme: AppBarTheme(
      centerTitle: true,
      elevation: 0,
    ),

    textTheme: GoogleFonts.nunitoTextTheme(),
  );
}