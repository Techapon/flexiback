import 'package:flexiback/config/theme/colors/app_color.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class DetailBox extends StatelessWidget {
  final String title;
  final String content;
  final IconData icon;
  final Color? contentColor;
  const DetailBox({
    super.key, 
    required this.title, 
    required this.content, 
    required this.icon,
    this.contentColor
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 8,
      children: [
        Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColor.base3,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppColor.grey2,
              width: 2
            )
          ),
          child: Icon(
            icon,
            size: 28,
            color: AppColor.grey4,
          ),
        ),

        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "$title",
              style: GoogleFonts.paytoneOne(
                color: AppColor.black1,
                fontSize: 16,
                // fontWeight: FontWeight.bold
              ),
            ),

            Text(
              content,
              style: TextStyle(
                color: contentColor ?? AppColor.grey4,
                fontSize: 14,
                fontWeight: FontWeight.bold
              ),
            ),
          ],
        )
      ],
    );
  }
}