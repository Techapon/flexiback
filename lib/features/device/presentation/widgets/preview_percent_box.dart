import 'package:flexiback/config/theme/colors/app_color.dart';
import 'package:flutter/material.dart';

class PreviewPercentBox extends StatelessWidget {
  final Color color;
  final String  title;
  final int percent;
  const PreviewPercentBox({
    super.key,
    required this.color,
    required this.title,
    required this.percent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16,horizontal: 20),
      decoration: BoxDecoration(
        color: color.withOpacity(.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: color.withOpacity(.7)
        )
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title.toUpperCase(),
            style: TextStyle(
              color: color,
              fontSize: 14,
              fontWeight: FontWeight.bold
            ),
          ),

          Text(
            "$percent%",
            style: TextStyle(
              color: AppColor.black1,
              fontSize: 14,
              fontWeight: FontWeight.bold
            ),
          )
        ],
      ),
    );
  }
}