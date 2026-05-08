import 'package:flexiback/config/theme/colors/app_color.dart';
import 'package:flutter/material.dart';

class LoadingStatus extends StatelessWidget {
  final String text;
  const LoadingStatus({
    super.key,
    required this.text
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        spacing: 12,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            alignment: AlignmentDirectional.center,
            children: [
              SizedBox(
                width: 80,
                height: 80,
                child: CircularProgressIndicator(
                  backgroundColor: AppColor.main1.withOpacity(.5),
                  strokeWidth: 4,
                  year2023: false,
                ),
              ),

              Image.asset(
                "assets/emoji/fox.png",
                height: 40,
                width: 40,
              )
            ],
          ),

          Text(
            text,
            style: TextStyle(
              color: AppColor.main2,
              fontSize: 16,
              fontWeight: FontWeight.bold
            ),
          )
        ],
      )
    );
  }
}