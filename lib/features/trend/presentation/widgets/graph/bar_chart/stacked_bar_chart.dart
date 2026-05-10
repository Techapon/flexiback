import 'package:fl_chart/fl_chart.dart';
import 'package:flexiback/config/theme/colors/app_color.dart';
import 'package:flexiback/features/trend/domain/entities/overview_entity.dart';
import 'package:flutter/material.dart';

class StackedBarChart extends StatefulWidget {
  final List<OverviewEntity> rawData;
  final Widget Function(List<OverviewEntity> data, int index) bottomTitle;
  final Function(int index) onTapBar;

  const StackedBarChart({
    super.key,
    required this.rawData,
    required this.bottomTitle,
    required this.onTapBar,
  });

  @override
  State<StackedBarChart> createState() => _StackedBarChartState();
}

class _StackedBarChartState extends State<StackedBarChart> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final minWidth = (widget.rawData.length * 50.0).clamp(screenWidth, double.infinity);

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
              barGroups: List.generate(widget.rawData.length, (i) {
                final item = widget.rawData[i];
                final good = item.goodPercentage ?? 0;
                final bad = item.badPercentage ?? 0;

                return BarChartGroupData(
                  x: i,
                  barRods: [
                    BarChartRodData(
                      toY: good + bad, // The total height of the stack
                      rodStackItems: [
                        BarChartRodStackItem(0, good, AppColor.success),
                        BarChartRodStackItem(good, good + bad, AppColor.error),
                      ],
                      width: 22,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(4)),
                    ),
                  ],
                );
              }),
              barTouchData: BarTouchData(
                touchCallback: (event, response) {
                  setState(() {
                    if (response?.spot == null || !event.isInterestedForInteractions) {
                      // Do nothing
                    } else {
                      final item = widget.rawData[response!.spot!.touchedBarGroupIndex];
                      if ((item.totalGoodTime ?? 0) == 0 && (item.totalBadTime ?? 0) == 0) return;
                      widget.onTapBar(response.spot!.touchedBarGroupIndex);
                    }
                  });
                },
                touchTooltipData: BarTouchTooltipData(
                  getTooltipColor: (_) => AppColor.main2.withOpacity(.8),
                  getTooltipItem: (group, index, rod, _) {
                    final item = widget.rawData[index];
                    if ((item.totalGoodTime ?? 0) == 0 && (item.totalBadTime ?? 0) == 0) return null;
                    return BarTooltipItem(
                      'G: ${item.goodPercentage?.toStringAsFixed(1)}%\nB: ${item.badPercentage?.toStringAsFixed(1)}%',
                      const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    );
                  },
                ),
              ),
              titlesData: FlTitlesData(
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 45,
                    getTitlesWidget: (value, meta) {
                      final int index = value.toInt();
                      if (index < 0 || index >= widget.rawData.length) {
                        return const SizedBox.shrink();
                      }
                      return SideTitleWidget(
                        meta: meta,
                        child: widget.bottomTitle(widget.rawData, index),
                      );
                    },
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    interval: 25,
                    showTitles: true,
                    reservedSize: 45,
                    getTitlesWidget: (value, meta) {
                      return SideTitleWidget(
                        // fitInside: SideTitleFitInsideData.fromTitleMeta(meta),
                        meta: meta,
                        child: Text(
                          "${value.toInt()}%",
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                      );
                    },
                  ),
                ),
                topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
              borderData: FlBorderData(
                show: true,
                border: Border(
                  left: BorderSide(color: AppColor.main2, width: 1.5),
                  bottom: BorderSide(color: AppColor.main1, width: 1.5),
                ),
              ),
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                horizontalInterval: 25,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
