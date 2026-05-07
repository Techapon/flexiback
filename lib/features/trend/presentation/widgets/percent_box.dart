import 'package:flexiback/config/theme/colors/app_color.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PercentBox extends StatelessWidget {
  final String title;
  final Color color;
  final IconData icon;
  final int percent;
  final String commentText;
  const PercentBox({
    super.key, 
    required this.title,
    required this.color, 
    required this.icon, 
    required this.percent,
    required this.commentText
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: 12,
        left: 12,
        right: 12,
        bottom: 26
      ),
      decoration: BoxDecoration(
        color: AppColor.base1,
        border: Border.all(
          color: AppColor.grey2,
          width: 1.5
        ),
        borderRadius: BorderRadius.circular(24)
      ),
      child: Column(
        spacing: 16,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            spacing: 4,
            children: [
              Container(
                padding: EdgeInsets.all(4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: AppColor.grey2,
                    width: 1.5
                  )
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 22,
                ),
              ),
              Text(
                title,
                style: GoogleFonts.paytoneOne(
                  color: color,
                  fontSize: 12,
                  fontWeight: FontWeight.bold
                ),
              )

            ],
          ),

          LinearProgressIndicator(
            value: percent / 100 ,
            backgroundColor: color.withOpacity(.4),
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 5,
            borderRadius: BorderRadius.circular(4),
          ),

          Column(
            spacing: 8,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${percent} %",
                style: GoogleFonts.paytoneOne(
                  color: color,
                  fontSize: 35,
                  height: .9
                ),
              ),
              Text(
                "$commentText!!",
                style: TextStyle(
                  color: AppColor.grey3,
                  fontSize: 14,
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}