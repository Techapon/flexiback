import 'package:flexiback/shared/theme/colors/app_color.dart';
import 'package:flutter/material.dart';

class ErrorStatus extends StatelessWidget {
  final String? text;
  const ErrorStatus({
    super.key,
    required this.text
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
          padding: EdgeInsets.all(12),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Some thing went wrong :",
                  style: TextStyle(
                    fontSize: 18,
                    color: AppColor.black1,
                    fontWeight: FontWeight.bold
                  ),
                ),
                Text(
                  text ?? "Please try again ...",
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColor.black1,
                  ),
                  textAlign: TextAlign.center,
                  softWrap: true,
                ),
              ],
            ),
          ),
        ),
      );
  }
}