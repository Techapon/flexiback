import 'package:flexiback/shared/theme/colors/app_color.dart';
import 'package:flutter/material.dart';

class LoadingStatus extends StatelessWidget {
  final String text;
  const LoadingStatus({
    super.key,
    required this.text
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: Column(
            spacing: 12,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 65,
                height: 65,
                child: CircularProgressIndicator(
                  strokeWidth: 5,
                  year2023: false,
                ),
              ),

              Text(
                text,
                style: TextStyle(
                  color: AppColor.main2,
                  fontSize: 16
                ),
              )
            ],
          )
        ),
      );
  }
}