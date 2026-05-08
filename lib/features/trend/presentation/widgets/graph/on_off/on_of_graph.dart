import 'package:fl_chart/fl_chart.dart';
import 'package:flexiback/config/theme/colors/app_color.dart';
import 'package:flexiback/core/entities/dot_entity.dart';
import 'package:flexiback/core/enums/dot_status.dart';
import 'package:flexiback/features/device/domain/entities/full_data_entity.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OnOfGraph extends StatefulWidget {
  final FullDataEntity fullData;
  const OnOfGraph({
    super.key, 
    required this.fullData
  });

  @override
  State<OnOfGraph> createState() => _OnOfGraphState();
}

class _OnOfGraphState extends State<OnOfGraph> {

  late List<DotEntity> dots = widget.fullData.dotList;
  late DotEntity beginDot = dots.first;

  late List<FlSpot> spots = List.generate(
    dots.length,
    (i) {
      final minute = dots[i].dateTime
        .difference(beginDot.dateTime)
        .inSeconds / 60;
      return FlSpot(minute, dots[i].status == DotStatus.good ? 2 : 1);
    } 
  );

  late double totalMinutes = widget.fullData.totalTime.inSeconds / 60;

  // Helper to get DateTime from spot index
  DateTime getDateTimeFromSpotIndex(int index) {
    if (index >= 0 && index < dots.length) {
      return dots[index].dateTime;
    }
    return beginDot.dateTime;
  }
  
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final minWidth = (dots.length * 8.5).clamp(screenWidth, double.infinity);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: screenWidth,
          minHeight: 300,
        ),
        child: SizedBox(
          width: minWidth,
          child: LineChart(mainData()),
        ),
      ),
    );
  }
  
  LineChartData mainData() {
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        horizontalInterval: 1,
        verticalInterval: 1,
        getDrawingHorizontalLine: (value) {
          return const FlLine(
            color: AppColor.grey2,
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return const FlLine(
            strokeWidth: 0,
          );
        },
      ),

      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        // Bottom Side
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 15,
            getTitlesWidget: (double value, TitleMeta meta) {
              const style = TextStyle(
                color: AppColor.grey4,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              );

              final dt = beginDot.dateTime.add(
                Duration(seconds: (value * 60).toInt()),
              );

              return SideTitleWidget(
                meta: meta,
                child: Text("${DateFormat('H:mm').format(dt)}", style: style),
              );
            }
          ),
        ),
        // Left Side
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 1,
            getTitlesWidget: (double value, TitleMeta meta) {
              const style = TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
              );
              String text = switch (value.toInt()) {
                1 => 'Bad',
                2 => 'Good',
                _ => '',
              };

              return Text(text, style: style, textAlign: TextAlign.left);
            },
            reservedSize: 32,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border(
          left: BorderSide(color: AppColor.main2,width: 1.5),
        )
      ),
      minX: 0,
      maxX: totalMinutes,
      minY: 0,
      maxY: 3,
      lineBarsData: [
        LineChartBarData(
          spots: spots,
          isCurved: false,
          gradient: LinearGradient(
            colors: AppColor.mainGradientColrs,
          ),
          barWidth: 3,
          isStrokeCapRound: false,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: AppColor.mainGradientColrs
                  .map((color) => color.withValues(alpha: 0.3))
                  .toList(),
            ),
          ),
        ),
      ],
      
      lineTouchData: LineTouchData(
        enabled: true,
        touchTooltipData: LineTouchTooltipData(
            getTooltipItems: (items) {
              return items.map(
                (spot) {
                  // Get the index from the spot and find corresponding DateTime
                  final index = spot.spotIndex;
                  final dateTime = getDateTimeFromSpotIndex(index);
                  final status = spot.y == 2 ? 'Good' : 'Bad';
                  
                  return LineTooltipItem(
                      "$status\n${DateFormat('HH:mm').format(dateTime)}",
                      TextStyle(
                        color: AppColor.black1
                      )
                  );
                }
              ).toList();
            }
        )
      )
    );
  }

  
}