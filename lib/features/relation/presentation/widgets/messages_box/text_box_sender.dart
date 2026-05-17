import 'package:flexiback/config/theme/colors/app_color.dart';
import 'package:flutter/material.dart';

class TextBoxSender extends StatelessWidget {
  final String text;
  const TextBoxSender({
    super.key,
    required this.text
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 64,right: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Flexible(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 8,horizontal: 16),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: AppColor.mainGradientColrs),
                borderRadius: BorderRadius.circular(14)
              ),
              child: Text(
                "${text}",
                style: TextStyle(
                  color: AppColor.base1,
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