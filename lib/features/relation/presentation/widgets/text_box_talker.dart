import 'package:flexiback/config/theme/colors/app_color.dart';
import 'package:flutter/material.dart';

class TextBoxTalker extends StatelessWidget {
  final String text;
  const TextBoxTalker({
    super.key,
    required this.text
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 16,right: 64),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Flexible(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 8,horizontal: 16),
              decoration: BoxDecoration(
                color: AppColor.grey1,
                borderRadius: BorderRadius.circular(14)
              ),
              child: Text(
                "${text}",
                style: TextStyle(
                  color: AppColor.black1,
                  fontSize: 14
                ),
                softWrap: true,
              ),
            ),
          ),
        ],
      ),
    );
  }
}