import 'package:flexiback/config/theme/colors/app_color.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class infoBox extends StatelessWidget {
  final String title;
  final Color color;
  final String sub;
  const infoBox({
    super.key,
    required this.title,
    required this.color,
    required this.sub,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 8,
      children: [
        Container(
          width: 25,
          height: 35,
          decoration: BoxDecoration(
            color: color,
            border: Border.all(
              color: AppColor.black1,
              width: .7
            ),
            borderRadius: BorderRadius.circular(6)
          ),
        ),

        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${title}",
              style: GoogleFonts.paytoneOne(
                color: AppColor.black1,
                fontSize: 14,
              ),
            ),
            Text(
              "${sub}",
              style: TextStyle(
                color: AppColor.grey3,
                fontSize: 14,
                fontWeight: FontWeight.bold
              ),
            )
          ],
        ),
      ],
    );
  }
}