import 'package:flexiback/config/theme/colors/app_color.dart';
import 'package:flexiback/features/device/domain/entities/daily_progress_entity.dart';
import 'package:flutter/material.dart';

class DetailScoreBar extends StatelessWidget {
  final List<DailyProgressEntity> rawData;
  final int currentIndex;
  final String Function(DateTime date) dateFormated;
  const DetailScoreBar({
    super.key, 
    required this.rawData,
    required this.currentIndex,
    required this.dateFormated
  });

  @override
  Widget build(BuildContext context) {
    (double,DateTime) currentData = currentIndex == 0 
      ? (rawData.first.straightScore ?? .0,rawData.first.dateTime!)
      : (rawData[currentIndex].straightScore ?? .0,rawData[currentIndex].dateTime!);
    print("$currentIndex : ${currentData}");

    return Container(
      height: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: AppColor.base3,
        border: Border.all(
          color: AppColor.grey2,
          width: 1.5
        ),
        borderRadius: BorderRadius.circular(8)
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Text(
                "Score ",
                style: TextStyle(
                  color: AppColor.grey4,
                  fontWeight: FontWeight.bold,
                  fontSize: 14
                ),
              ),
              Text(
                "${currentData.$1.toStringAsFixed(1)}",
                style: TextStyle(
                  color: AppColor.black1,
                  fontSize: 18,
                  fontWeight: FontWeight.bold
                ),
              ),
            ],
          ),
          Row(
            children: [
              Text(
                ", At ",
                style: TextStyle(
                  color: AppColor.grey4,
                  fontWeight: FontWeight.bold,
                  fontSize: 14
                ),
              ),
              Text(
                "${dateFormated(currentData.$2)}",
                style: TextStyle(
                  color: AppColor.black1,
                  fontSize: 18,
                  fontWeight: FontWeight.bold
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}