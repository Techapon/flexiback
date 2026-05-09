import 'package:fl_chart/fl_chart.dart';
import 'package:flexiback/config/theme/colors/app_color.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SimpleBarChart extends StatefulWidget {
  const SimpleBarChart({super.key});

  @override
  State<SimpleBarChart> createState() => _SimpleBarChartState();
}

class _SimpleBarChartState extends State<SimpleBarChart> {
  int touchedIndex = -1;

  final List<(DateTime, double)> data = [
    (DateTime(2025, 1, 6), 50.0),
    (DateTime(2025, 1, 7), 0),
    (DateTime(2025, 1, 8), 60),
    (DateTime(2025, 1, 9), 75),
    (DateTime(2025, 1, 10), 76),
    (DateTime(2025, 1, 11), 0),
    (DateTime(2025, 1, 12), 81.2),
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final minWidth = (data.length * 8.5).clamp(screenWidth, double.infinity);

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
              barGroups: List.generate(7, (i) {
              
                final isTouched = i == touchedIndex;
                
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
                      touchedIndex = -1;
                    } else {
                      touchedIndex = response!.spot!.touchedBarGroupIndex;
                    }
                  });
                },
                touchTooltipData: BarTouchTooltipData(
                  getTooltipColor: (_) => Colors.blueGrey,
                  getTooltipItem: (group, index, rod,_) => BarTooltipItem(
                    // '${data[group.x]}\n${(rod.toY).toStringAsFixed(1)}',
                    '${DateFormat("dd/MM").format(data[index].$1)}\n${data[index].$2}',
                    const TextStyle(color: Colors.white),
                  ),
                ),
              ),
              
              // ── 3. Label แกน X ──
              titlesData: FlTitlesData(
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 32,
                    getTitlesWidget: (value, meta) {
                      final int index = value.toInt();
                      
                      if (index < 0 || index >= data.length) {
                        return const SizedBox.shrink();
                      }
              
                      return SideTitleWidget(
                        meta: meta,
                        child: Text(
                          DateFormat("dd/MM").format(data[index].$1),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      );
                    }
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    interval: 50,
                    showTitles: true,
                    reservedSize: 50,
                    getTitlesWidget: (value, meta) {
                      return SideTitleWidget(
                        meta: meta,
                        child: Text(
                          "${value.toInt()}",
                          style: const TextStyle(fontWeight: FontWeight.bold),
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