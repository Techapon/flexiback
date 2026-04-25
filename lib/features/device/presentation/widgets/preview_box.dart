import 'package:flexiback/config/theme/colors/app_color.dart';
import 'package:flutter/material.dart';

class PreviewBox extends StatelessWidget {
  final Color color;
  final String title;
  final String time;
  const PreviewBox({
    super.key,
    required this.color,
    required this.title,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 18
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(.1),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: color.withOpacity(.5)
        )
      ),
      child: Column(
        spacing: 8,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title.toUpperCase(),
            style: TextStyle(
              color: color,
              fontSize: 10,
              fontWeight: FontWeight.bold
            ),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            spacing: 4,
            children: [
              Text(
                time,
                style: TextStyle(
                  color: color,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "h.",
                style: TextStyle(
                  color: color.withOpacity(.7),
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  height: 2.3
                ),
              ),
            ],
          ),


        ],
      ),
    );
  }
}