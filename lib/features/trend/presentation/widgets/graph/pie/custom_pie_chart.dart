import 'package:fl_chart/fl_chart.dart';
import 'package:flexiback/config/theme/colors/app_color.dart';
import 'package:flutter/material.dart';

class CustomPieChart extends StatelessWidget {
  final double gPer;
  const CustomPieChart({
    super.key, 
    required this.gPer
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.orange,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColor.base1,
        boxShadow: [
          BoxShadow(
            color: AppColor.black1.withOpacity(.25),
            offset: Offset(0, 2.5),
            blurRadius: 10,
            spreadRadius : 1
          )
        ]
      ),
      child: SizedBox(
        height: 130,
        width: 130,
        child: Stack(
          alignment: Alignment.center,
          children: [
            PieChart(
              PieChartData(
                sectionsSpace: 0,
                centerSpaceRadius: 40,
                startDegreeOffset: 270,
                sections: [
                  PieChartSectionData(
                    color: AppColor.success,
                    value: gPer,
                    radius: 25,
                    showTitle: false,
                  ),
                  PieChartSectionData(
                    color: AppColor.error,
                    value: 100-gPer,
                    radius: 25,
                    showTitle: false,
                  )
                ]
              )
            ),
      
            
          ],
        ),
      ),
    );
  }
}