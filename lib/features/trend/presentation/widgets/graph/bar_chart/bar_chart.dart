import 'package:fl_chart/fl_chart.dart';
import 'package:flexiback/config/theme/colors/app_color.dart';
import 'package:flexiback/core/utils/week_getter.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../device/domain/entities/daily_progress_entity.dart';

class SimpleBarChart extends StatefulWidget {
  List<DailyProgressEntity> rawData;
  Widget Function(List<(DateTime, double)> data,int index) bottomTitle;
  Function(int index) onTapBar;
  SimpleBarChart({
    super.key, 
    required this.rawData,
    required this.bottomTitle,
    required this.onTapBar
  });

  @override
  State<SimpleBarChart> createState() => _SimpleBarChartState();
}

class _SimpleBarChartState extends State<SimpleBarChart> {

  @override
  Widget build(BuildContext context) {
    late List<(DateTime, double)> data = List.generate(
      widget.rawData.length,
      (i) {
        return (widget.rawData[i].dateTime!,widget.rawData[i].straightScore!);
      }
    );

    final screenWidth = MediaQuery.of(context).size.width;
    final minWidth = (data.length * 50.0).clamp(screenWidth, double.infinity);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      clipBehavior: Clip.none,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: screenWidth,
          minHeight: 300,
        ),
        child: SizedBox(
          width: minWidth,
          child: BarChart(
            BarChartData(
              minY: 0,
              maxY: 100,
              // ── 1. กำหนด Bar แต่ละแท่ง ──
              barGroups: List.generate(data.length, (i) {
              
                // final isTouched = i == touchedIndex;
                
                return BarChartGroupData(
                  x: i,
                  barRods: [
                    BarChartRodData(
                      toY: data[i].$2,
                      // color: isTouched ? Colors.green : AppColor.main2,
                      gradient: const LinearGradient(
                        colors: AppColor.mainGradientColrs,
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                      width: 22,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(4))
                    ),
                  ],
                );
              }),
              
              // ── 2. Tooltip เมื่อกด ──
              barTouchData: BarTouchData(
                touchCallback: (event, response) {
                  setState(() {
                    if (response?.spot == null || !event.isInterestedForInteractions) {
                      
                    } else {
                      if (data[response!.spot!.touchedBarGroupIndex].$2 == 0) return;
                      widget.onTapBar(response!.spot!.touchedBarGroupIndex);
                    }
                  });
                },
                touchTooltipData: BarTouchTooltipData(
                  getTooltipColor: (_) => AppColor.main2.withOpacity(.8),
                  getTooltipItem: (group, index, rod,_) => data[index].$2 != 0
                  ? BarTooltipItem(
                    // '${data[group.x]}\n${(rod.toY).toStringAsFixed(1)}',
                    'score : ${data[index].$2.toStringAsFixed(1)}',
                    TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
                  )
                  :null,
                ),
              ),
              
              // ── 3. Label แกน X ──
              titlesData: FlTitlesData(
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 49,
                    getTitlesWidget: (value, meta) {
                      final int index = value.toInt();
                      
                      if (index < 0 || index >= data.length) {
                        return const SizedBox.shrink();
                      }

                      final child = widget.bottomTitle(data,index);
              
                      return SideTitleWidget(
                        meta: meta,
                        child: child,
                      );
                    }
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    interval: 50,
                    showTitles: true,
                    reservedSize: 32,
                    getTitlesWidget: (value, meta) {
                      return SideTitleWidget(
                        fitInside: SideTitleFitInsideData.fromTitleMeta(meta),
                        meta: meta,
                        child: Text(
                          "${value.toInt()}",
                          style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 12),
                        ),
                      );
                    }
                  )
                ),
                // ซ่อนแกนอื่นๆ
                topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
              
              borderData: FlBorderData(
                show: true,
                border: Border(
                  left: BorderSide(
                    color: AppColor.main2,
                    width: 1.5
                  ),
                  bottom: BorderSide(
                    color: AppColor.main1,
                    width: 1.5
                  )
                )
              ),
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                horizontalInterval: 50
              ),
            ),
          ),
        ),
      ),
    );
  }
}