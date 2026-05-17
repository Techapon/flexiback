import 'package:flexiback/config/theme/colors/app_color.dart';
import 'package:flexiback/core/entities/image_text_entity.dart';
import 'package:flexiback/core/utils/month_getter.dart';
import 'package:flexiback/core/utils/week_getter.dart';
import 'package:flexiback/features/device/domain/entities/daily_progress_entity.dart';
import 'package:flexiback/features/trend/domain/enums/chart_period.dart';
import 'package:flexiback/features/trend/domain/enums/record_type.dart';
import 'package:flexiback/features/trend/domain/enums/usage_view_mode.dart';
import 'package:flexiback/features/trend/domain/service/charts/aggegate_daily_progress.dart';
import 'package:flexiback/features/trend/domain/service/charts/fill_the_gap_day.dart';
import 'package:flexiback/features/trend/domain/service/charts/fill_the_gap_month.dart';
import 'package:flexiback/features/trend/domain/service/charts/divide_month.dart';
import 'package:flexiback/features/trend/domain/service/charts/aggregate_device_usage_day.dart';
import 'package:flexiback/features/trend/domain/service/charts/aggregate_device_usage_month.dart';
import 'package:flexiback/features/trend/domain/service/charts/fill_the_gap_device_usage_day.dart';
import 'package:flexiback/features/trend/domain/service/charts/fill_the_gap_device_usage_month.dart';
import 'package:flexiback/features/trend/domain/service/charts/aggregate_therapy_session_day.dart';
import 'package:flexiback/features/trend/domain/service/charts/aggregate_therapy_session_month.dart';
import 'package:flexiback/features/trend/presentation/widgets/date_bar.dart';
import 'package:flexiback/features/trend/presentation/widgets/graph/bar_chart/stacked_bar_chart.dart';
import 'package:flexiback/features/trend/presentation/controller/trend_provider.dart';
import 'package:flexiback/features/trend/presentation/widgets/daily_card_hozi.dart';
import 'package:flexiback/features/trend/presentation/widgets/detail_box.dart';
import 'package:flexiback/features/trend/presentation/widgets/detail_score_bar.dart';
import 'package:flexiback/features/trend/presentation/widgets/graph/bar_chart/bar_chart.dart';
import 'package:flexiback/features/trend/presentation/widgets/graph/on_off/on_of_graph.dart';
import 'package:flexiback/features/trend/presentation/widgets/graph/pie/custom_pie_chart.dart';
import 'package:flexiback/features/trend/presentation/widgets/info_box.dart';
import 'package:flexiback/features/trend/presentation/widgets/table_calendar.dart';
import 'package:flexiback/shared/widgets/appbar/appbar1.dart';
import 'package:flexiback/shared/widgets/form/dropdown.dart';
import 'package:flexiback/shared/widgets/status/loading/loading_status.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:lucide_icons_flutter/test_icons.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../../shared/widgets/form/dropdown_img.dart';
import '../../domain/entities/overview_entity.dart';

class GraphTrend extends StatefulWidget {
  final String? userId;
  final DateTime? lastedtDay;
  final bool fromCalendar;
  const GraphTrend({
    super.key, 
    required this.userId,
    required this.lastedtDay,
    required this.fromCalendar
  });

  @override
  State<GraphTrend> createState() => _GraphTrendState();
}

class _GraphTrendState extends State<GraphTrend> {
  late ValueNotifier<String?> valueListenable_recordType;

  List<ImageTextEntity> recordType = [
    ImageTextEntity(path: "assets/emoji/setting.png",text: RecordType.deviceUsage.entity, decorate: ''),
    ImageTextEntity(path: "assets/emoji/graph.png",text: RecordType.dailyProgress.entity, decorate: ''),
    ImageTextEntity(path: "assets/emoji/therapy.png",text: RecordType.therapySession.entity, decorate: '')
  ];

  RecordType recordTypeSelected = RecordType.deviceUsage;

  // Device Usage Mode
  UsageViewMode usageViewMode = UsageViewMode.result;

  // Device Usage Trend
  late ValueNotifier<String?> valueListenable_usagePeriod;
  List<String> usagePeriod = [
    ChartPeriod.day.entity,
    ChartPeriod.month.entity
  ];
  ChartPeriod usagePeriodSelected = ChartPeriod.day;
  int usageBarTouchCurrentIndex = 0;


  // Daily
  late ValueNotifier<String?> valueListenable_dailyPeroid;

  List<String> dailyPeroid = [
    ChartPeriod.day.entity,
    ChartPeriod.month.entity
  ];

  ChartPeriod dailyPeroidSelected = ChartPeriod.day;

  late final TrendProvider _trendProvider;

  // Logic
  int dailyBarTouchCurrentIndex = 0;

  @override
  void initState() {
    super.initState();

    valueListenable_recordType = ValueNotifier(recordType[0].text);
    valueListenable_usagePeriod = ValueNotifier(usagePeriod[0]);
    valueListenable_dailyPeroid = ValueNotifier(dailyPeroid[0]);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _trendProvider = context.read<TrendProvider>();
      _trendProvider.getDailyProgress(widget.userId!);
      _trendProvider.getTherapySessions(widget.userId!);

      if (_trendProvider.fullData == null && widget.fromCalendar != true) {
        _trendProvider.getFullDataUsage(widget.userId!, widget.lastedtDay!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final TrendProvider trendProvider = context.watch<TrendProvider>();
    
    return Scaffold(
      appBar: Appbar1(title: "trend"),
      backgroundColor: AppColor.base1,
      body: SafeArea(
        child: Column(
          spacing: 16,
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: 16, right: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomDropdownImage(
                      valueListenable_title: valueListenable_recordType,
                      listItem: recordType,
                      onChanged: (value) {
                        setState(() {
                          recordTypeSelected = RecordType.fromEntity(value);
                        });
                      }
                    ),

                    SizedBox(height: 16),
                    
                    if (trendProvider.fullData == null) ...[
                      Container(
                        height: MediaQuery.of(context).size.height * 0.75,
                        child: Center(
                          child: LoadingStatus(text: "Loading Lastest Data..."),
                        ),
                      )
                    ] else ... [
                      // Head title
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        spacing: 8,
                        children: [
                          Text(
                            recordTypeSelected.entity,
                            style: GoogleFonts.paytoneOne(
                              color: AppColor.black1,
                              fontSize: 30,
                            ),
                          ),

                          if (recordTypeSelected == RecordType.deviceUsage) ...[
                            Padding(
                              padding: EdgeInsets.only(top: 3),
                              child: GestureDetector(
                                onTap: () {
                                  final deviceUsageCalendar = trendProvider.deviceUsageCalendar!;

                                  showDialog(
                                        context: context, 
                                        builder: (context) {
                                          return Dialog(
                                            insetPadding: EdgeInsets.symmetric(horizontal: 16),
                                            backgroundColor: Colors.transparent,
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                ConstrainedBox(
                                                  constraints: BoxConstraints(
                                                    maxWidth: 400
                                                  ),
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      color: AppColor.base2,
                                                      borderRadius: BorderRadius.circular(24),
                                                    ),
                                                    child: Calendar(
                                                      userId: widget.userId!,
                                                      first: deviceUsageCalendar.first,
                                                      focus: deviceUsageCalendar.focus, 
                                                      last: deviceUsageCalendar.last, 
                                                      usageDates: deviceUsageCalendar.usageDates, 
                                                      ontap: (selectedDay,focusDay) {
                                                        bool isInSelected = deviceUsageCalendar.usageDates.any((dayinList) => isSameDay(dayinList, selectedDay));

                                                        if (isInSelected) {
                                                          trendProvider.getFullDataUsage(widget.userId!, selectedDay);
                                                          Navigator.pop(context);
                                                        }
                                                      }
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        }
                                      );
                                },
                                child: ShaderMask(
                                  blendMode: BlendMode.srcIn, 
                                  shaderCallback: (Rect bounds) {
                                    return LinearGradient(
                                      colors: AppColor.mainGradientColrs,
                                    ).createShader(bounds); 
                                  },
                                  child: Icon(
                                    LucideIcons.calendar,
                                    color: AppColor.base1,
                                    size: 30,
                                  ),
                                ),
                              ),
                            )
                          ]
                        ],
                      ),

                      // Uage View Radio
                      if (recordTypeSelected == RecordType.deviceUsage) ...[
                        if (usageViewMode == UsageViewMode.result) ...[
                          Expanded(
                            child: SingleChildScrollView(
                              child: Column(
                                spacing: 16,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    trendProvider.fullData != null
                                      ? "${trendProvider.fullData!.formattedDate}"
                                      : '. . .',
                                    style: TextStyle(
                                      color: AppColor.grey3,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold
                                    ),
                                  ),

                                  Container(
                                    child: AspectRatio(
                                      aspectRatio: 1.5,
                                      child: OnOfGraph(fullData: trendProvider.fullData!,)
                                    )
                                  ),
                                  
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 16,vertical: 8),
                                    child: Column(
                                      spacing: 16,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              spacing: 32,
                                              children: [
                                                infoBox(title: "Good",color: AppColor.success,sub: "${trendProvider.fullData!.goodTimeFormatted} h. - ${trendProvider.fullData!.goodPercentage}%",),
                                                infoBox(title: "Bad",color: AppColor.error,sub: "${trendProvider.fullData!.badTimeFormatted} h. - ${trendProvider.fullData!.badPercentage}%",),
                                              ],
                                            ),
                                            CustomPieChart(
                                              gPer: trendProvider.fullData!.goodPercentage,
                                            )
                                          ],
                                        ),

                                        Column(
                                          spacing: 16,
                                          children: [
                                            DetailBox(
                                              title: 'Period',
                                              content: '${trendProvider.fullData!.startAt} to ${trendProvider.fullData!.endAt}',
                                              icon: LucideIcons.clock8,
                                            ),

                                            DetailBox(
                                              title: 'Total Usage',
                                              content: '${trendProvider.fullData!.totalTimeFormatted} h.',
                                              icon: LucideIcons.hourglass,
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),                          
                                ],
                              ),
                            ),
                          )
                        ] else if (usageViewMode == UsageViewMode.trend) ...[
                          Expanded(
                            child: SingleChildScrollView(
                              clipBehavior: Clip.antiAlias,
                              child: Column(
                                spacing: 16,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [

                                  Builder(
                                    builder: (context) {
                                      final aggregatedByDay = trendProvider.deviceOverviewList ?? [];

                                      String Function(List<OverviewEntity>, int) botTitle1 = usagePeriodSelected == ChartPeriod.day
                                        ? (data, index) => "${weekGetter(data[index].dateTime!.weekday)}."
                                        : (data, index) => "${monthGetter(data[index].dateTime!.month)}.";

                                      String botTitle2 = usagePeriodSelected == ChartPeriod.day
                                        ? "d/M/yy"
                                        : "yyyy";
                                      
                                      List<OverviewEntity> chartData = [];
                                      if (usagePeriodSelected == ChartPeriod.day) {
                                        chartData = fillTheGapDeviceUsageDay(aggregatedByDay);
                                      } else if (usagePeriodSelected == ChartPeriod.month) {
                                        final aggregatedByMonth = aggregateDeviceUsageMonth(aggregatedByDay);
                                        chartData = fillTheGapDeviceUsageMonth(aggregatedByMonth);
                                      }

                                      String Function(DateTime) dateFormatDetail = usagePeriodSelected == ChartPeriod.day
                                        ? (date) => "${weekGetter(date.weekday)}. ${DateFormat("d / M / yyyy").format(date)}"
                                        : (date) => "${monthGetter(date.month)}. ${DateFormat("yyyy").format(date)}";

                                      final currentUsageBarData = chartData[usageBarTouchCurrentIndex];

                                      final int originCurrentIndex = aggregatedByDay.indexWhere(
                                      (e) => e.dateTime != null && currentUsageBarData.dateTime != null &&
                                            e.dateTime!.year == currentUsageBarData.dateTime!.year &&
                                            e.dateTime!.month == currentUsageBarData.dateTime!.month &&
                                            e.dateTime!.day == currentUsageBarData.dateTime!.day
                                      );

                                      final OverviewEntity? currentOriginData = originCurrentIndex != -1 ? aggregatedByDay[originCurrentIndex] : null;

                                      final Duration? change = (originCurrentIndex <= 0 || currentOriginData?.totalGoodTime == null)
                                        ? null
                                        : Duration(seconds: (currentOriginData!.totalGoodTime! - aggregatedByDay[originCurrentIndex-1].totalGoodTime!).toInt());
                                        
                                      final double? changePercent = (change == null || currentOriginData?.totalGoodTime == null || currentOriginData!.totalGoodTime == 0)
                                        ? null
                                        : currentOriginData.goodPercentage! - aggregatedByDay[originCurrentIndex-1].goodPercentage!;

                                      return Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        spacing: 16,
                                        children: [
                                          Text(
                                            "${DateFormat("dd / MM / yy").format(chartData.first.dateTime!)} - ${DateFormat("dd / MM / yy").format(chartData.last.dateTime!)}",
                                            style: TextStyle(
                                              color: AppColor.grey3,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold
                                            ),
                                          ),
                                          
                                          Container(
                                            child: AspectRatio(
                                              aspectRatio: 1.5,
                                              child: StackedBarChart(
                                                rawData: chartData,
                                                bottomTitle: (data, index) {
                                                  // final date = data[index].dateTime!;
                                                  // String title = '';
                                                  // if (usagePeriodSelected == ChartPeriod.day) {
                                                  //   title = weekGetter(date.weekday);
                                                  // } else {
                                                  //   title = monthGetter(date.month);
                                                  // }

                                                  return Column(
                                                    children: [
                                                      Text(
                                                        "${botTitle1(data,index)}",
                                                        style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14),
                                                      ),
                                                      Text(
                                                        DateFormat("$botTitle2").format(data[index].dateTime!),
                                                        style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12),
                                                      ),
                                                    ],
                                                  );
                                                },
                                                onTapBar: (index) {
                                                  setState(() {
                                                    usageBarTouchCurrentIndex = index;
                                                  });
                                                },
                                              )
                                            )
                                          ),
                                          
                                          IntrinsicHeight(
                                            child: Row(
                                              spacing: 8,
                                              children: [
                                                IntrinsicWidth(
                                                  child: Custom_Dropdown(
                                                    valueListenable_title: valueListenable_usagePeriod,
                                                    List_items: usagePeriod,
                                                    onChanged: (value) {
                                                      setState(() {
                                                        usagePeriodSelected = ChartPeriod.fromEntity(value);
                                                        usageBarTouchCurrentIndex = 0; // reset
                                                      });
                                                    }
                                                  ),
                                                ),
                                            
                                                Expanded(
                                                  child: DateBar(title: "On ",date: "${dateFormatDetail(currentUsageBarData.dateTime!)}",)
                                                )
                                              ],
                                            ),
                                          ),

                                          Padding(
                                            padding: EdgeInsets.only(left: 16),
                                            child: Column(
                                              spacing: 16,
                                              children: [
                                                  Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    spacing: 8,
                                                    children: [
                                                      infoBox(title: "Good",color: AppColor.success,sub: "${currentUsageBarData.goodTimeFormatted} h. - ${currentUsageBarData.goodPercentage?.toStringAsFixed(1)}%",),
                                                      infoBox(title: "Bad",color: AppColor.error,sub: "${currentUsageBarData.badTimeFormatted} h. - ${currentUsageBarData.badPercentage?.toStringAsFixed(1)}%",),
                                                    ],
                                                  ),

                                                  DetailBox(
                                                    icon: change != null 
                                                      ? change.inSeconds > 0 ? LucideIcons.trendingUp : LucideIcons.trendingDown
                                                      : LucideIcons.minus,
                                                    title: "Change",
                                                    content: change == null 
                                                      ? '--' 
                                                      : "${change.inHours}.${(change.inMinutes % 60).toString().padLeft(2,'0')} hour, ${changePercent!.toStringAsFixed(2)}% change",
                                                    contentColor: change != null 
                                                      ? change.inSeconds > 0 ? AppColor.green1 : AppColor.red1
                                                      : null,
                                                  ),
                                                  DetailBox(
                                            title: 'Total Usage',
                                            content: '${currentUsageBarData.totalTimeFormatted} h.',
                                            icon: LucideIcons.hourglass,
                                          ),
                                              ],
                                            ),
                                          )
                                          // Detail placeholder for User
                                          // Padding(
                                          //   padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                          //   child: Center(
                                          //     child: Text(
                                          //       "Selected: ${DateFormat("dd/MM/yyyy").format(chartData[usageBarTouchCurrentIndex].dateTime!)}\n"
                                          //       "Good: ${chartData[usageBarTouchCurrentIndex].totalTimeFormatted} h. (${chartData[usageBarTouchCurrentIndex].goodPercentage}%)\n"
                                          //       "Bad: ${chartData[usageBarTouchCurrentIndex].badPercentage}%\n"
                                          //       "(* เตรียมพื้นที่ให้ผู้ใช้เพิ่ม List detail *)",
                                          //       textAlign: TextAlign.center,
                                          //       style: TextStyle(color: AppColor.main1, fontWeight: FontWeight.bold),
                                          //     ),
                                          //   ),
                                          // ),
                                        ],
                                      );
                                    }
                                  )
                                  ,
                                  
                                
                                ],
                              ),
                            ),
                          )
                        ],

                        Container(
                          padding: EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: AppColor.base2,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () => setState(() => usageViewMode = UsageViewMode.result),
                                  child: Container(
                                    padding: EdgeInsets.symmetric(vertical: 8),
                                    decoration: BoxDecoration(
                                      color: usageViewMode == UsageViewMode.result ? AppColor.main2 : Colors.transparent,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Center(
                                      child: Text(
                                        "Result",
                                        style: TextStyle(
                                          color: usageViewMode == UsageViewMode.result ? Colors.white : AppColor.grey3,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () => setState(() => usageViewMode = UsageViewMode.trend),
                                  child: Container(
                                    padding: EdgeInsets.symmetric(vertical: 8),
                                    decoration: BoxDecoration(
                                      color: usageViewMode == UsageViewMode.trend ? AppColor.main2 : Colors.transparent,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Center(
                                      child: Text(
                                        "Trend",
                                        style: TextStyle(
                                          color: usageViewMode == UsageViewMode.trend ? Colors.white : AppColor.grey3,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                      
                      if (recordTypeSelected == RecordType.dailyProgress)
                        (){
                          final originData = trendProvider.dailyProgressList!;
                          final rawData = dailyPeroidSelected == ChartPeriod.day
                            ? fillTheGapDay(originData)
                            : fillTheGapMonth(aggegateDailyProgressMonth(originData));

                          String Function(List<(DateTime, double)>, int) botTitle1 = dailyPeroidSelected == ChartPeriod.day
                            ? (data, index) => "${weekGetter(data[index].$1.weekday)}."
                            : (data, index) => "${monthGetter(data[index].$1.month)}.";

                          String botTitle2 = dailyPeroidSelected == ChartPeriod.day
                            ? "d/M/yy"
                            : "yyyy";

                          String Function(DateTime) dateFormat = dailyPeroidSelected == ChartPeriod.day
                            ? (date) => DateFormat("dd / MM / yy").format(date)
                            : (date) => DateFormat("MM / yy").format(date);

                          String Function(DateTime) dateFormatDetail = dailyPeroidSelected == ChartPeriod.day
                            ? (date) => DateFormat("d/M/yy").format(date)
                            : (date) => DateFormat("M/yy").format(date);

                          final DailyProgressEntity curentData = rawData[dailyBarTouchCurrentIndex];
                        
                          final int originCurrentIndex = originData.indexWhere(
                            (e) => e.dateTime != null && curentData.dateTime != null &&
                                   e.dateTime!.year == curentData.dateTime!.year &&
                                   e.dateTime!.month == curentData.dateTime!.month &&
                                   e.dateTime!.day == curentData.dateTime!.day
                          );
                          final DailyProgressEntity? currentOriginData = originCurrentIndex != -1 ? originData[originCurrentIndex] : null;

                          final double? change = (originCurrentIndex <= 0 || currentOriginData?.straightScore == null)
                            ? null
                            : currentOriginData!.straightScore! - originData[originCurrentIndex-1].straightScore!;
                          final double? changePercent = (change == null || currentOriginData?.straightScore == null || currentOriginData!.straightScore == 0)
                            ? null
                            : (change / currentOriginData.straightScore!)*100;

                          // Month
                          final Map<String, List<DailyProgressEntity>> monthlyGroups = divideMonth(originData);
                          final String selectedMonthKey = curentData.dateTime != null
                            ? "${curentData.dateTime!.year}-${curentData.dateTime!.month.toString().padLeft(2, '0')}"
                            : "";
                          final List<DailyProgressEntity> monthlyItems = monthlyGroups[selectedMonthKey] ?? [];
                                            
                          return Expanded(
                            child: Column(
                              spacing: 16,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  trendProvider.dailyProgressList != null
                                    ? "${dateFormat(rawData.first.dateTime!)} - ${dateFormat(rawData.last.dateTime!)}"
                                    : '. . .',
                                  style: TextStyle(
                                    color: AppColor.grey3,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold
                                  ),
                                ),
                          
                                Expanded(
                                  child: SingleChildScrollView(
                                    // clipBehavior: Clip.none,
                                    child: Column(
                                      spacing: 16,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          child: AspectRatio(
                                            aspectRatio: 1.5,
                                            child: SimpleBarChart(
                                              maxY: 100,
                                              rawData: rawData.map((e) => (e.dateTime!, e.straightScore!)).toList(),
                                              bottomTitle: (data,index) {
                                                return Column(
                                                  children: [
                                                    Text(
                                                      "${botTitle1(data,index)}",
                                                      style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14),
                                                    ),
                                                    Text(
                                                      DateFormat("$botTitle2").format(data[index].$1),
                                                      style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12),
                                                    ),
                                                  ],
                                                );
                                              },
                                              onTapBar: (index) {
                                                setState(() {
                                                  dailyBarTouchCurrentIndex = index;
                                                });
                                              },
                                            )
                                          ),
                                        ),
                                    
                                        Container(
                                          child: Column(
                                            spacing: 16,
                                            children: [
                                              IntrinsicHeight(
                                                child: Row(
                                                  spacing: 8,
                                                  children: [
                                                    IntrinsicWidth(
                                                      child: Custom_Dropdown(
                                                        valueListenable_title: valueListenable_dailyPeroid,
                                                        List_items: dailyPeroid,
                                                        onChanged: (vale) {
                                                          setState(() {
                                                            dailyBarTouchCurrentIndex = 0;
                                                            dailyPeroidSelected = ChartPeriod.fromEntity(vale);
                                                          });
                                                        },
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: DetailScoreBar(
                                                        score: curentData.straightScore ?? 0.0,
                                                        date: curentData.dateTime!,
                                                        dateFormated: (date) => dateFormatDetail(date),
                                                      )
                                                    )
                                                  ],
                                                ),
                                              ),
                                    
                                              DetailBox(
                                                icon: change != null 
                                                  ? change > 0 ? LucideIcons.trendingUp : LucideIcons.trendingDown
                                                  : LucideIcons.minus,
                                                title: "Change",
                                                content: change == null 
                                                  ? '--' 
                                                  : "${change} scores, ${changePercent!.toStringAsFixed(2)}% change",
                                                contentColor: change != null 
                                                  ? change > 0 ? AppColor.green1 : AppColor.red1
                                                  : null,
                                              ),
                                    
                                               dailyPeroidSelected == ChartPeriod.day
                                                 ? IntrinsicHeight(
                                                    child: DailyCardHozi(
                                                      item: rawData[dailyBarTouchCurrentIndex],
                                                    )
                                                  )
                                                 : monthlyItems.isEmpty
                                                   ? Container(
                                                       padding: EdgeInsets.all(16),
                                                       child: Center(
                                                         child: Text(
                                                           "No data for this month",
                                                           style: TextStyle(color: AppColor.grey3, fontSize: 14),
                                                         ),
                                                       ),
                                                     )
                                                   : Column(
                                                       spacing: 8,
                                                       children: monthlyItems.map((item) => IntrinsicHeight(child: DailyCardHozi(item: item))).toList(),
                                                     ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                )
                                                  
                              ],
                            ),
                          );
                        }(),

                      if (recordTypeSelected == RecordType.therapySession)
                        (){
                          final originData = trendProvider.therapySessionList ?? [];
                          if (originData.isEmpty) {
                            return Expanded(
                              child: Center(
                                child: Text("No Therapy Sessions", style: TextStyle(color: AppColor.grey3, fontWeight: FontWeight.bold, fontSize: 16))
                              )
                            );
                          }
                          
                          final rawData = dailyPeroidSelected == ChartPeriod.day
                            ? aggregateTherapySessionDay(originData)
                            : aggregateTherapySessionMonth(originData);

                          String Function(List<(DateTime, double)>, int) botTitle1 = dailyPeroidSelected == ChartPeriod.day 
                            ? (data, index) => "${weekGetter(data[index].$1.weekday)}."
                            : (data, index) => "${monthGetter(data[index].$1.month)}.";
                            
                          String botTitle2 = dailyPeroidSelected == ChartPeriod.day 
                            ? "d/M/yy"
                            : "yy";

                          String Function(DateTime) dateFormat = (date) => DateFormat("dd / MM / yy").format(date);
                          String Function(DateTime) dateFormatDetail = (date) => DateFormat("d/M/yy").format(date);

                          final curentData = rawData[dailyBarTouchCurrentIndex];
                          final int originCurrentIndex = dailyBarTouchCurrentIndex;

                          final double? change = (originCurrentIndex <= 0)
                            ? null
                            : curentData.$2 - rawData[originCurrentIndex-1].$2;

                          final double? changePercent = (change == null || curentData.$2 == 0)
                            ? null
                            : (change / curentData.$2) * 100;

                          return Expanded(
                            child: Column(
                              spacing: 16,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${dateFormat(rawData.first.$1)} - ${dateFormat(rawData.last.$1)}",
                                  style: TextStyle(
                                    color: AppColor.grey3,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold
                                  ),
                                ),
                          
                                Expanded(
                                  child: SingleChildScrollView(
                                    child: Column(
                                      spacing: 16,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          child: AspectRatio(
                                            aspectRatio: 1.5,
                                            child: SimpleBarChart(
                                              rawData: rawData,
                                              bottomTitle: (data,index) {
                                                return Column(
                                                  children: [
                                                    Text(
                                                      "${botTitle1(data,index)}",
                                                      style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14),
                                                    ),
                                                    Text(
                                                      DateFormat("$botTitle2").format(data[index].$1),
                                                      style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12),
                                                    ),
                                                  ],
                                                );
                                              },
                                              onTapBar: (index) {
                                                setState(() {
                                                  dailyBarTouchCurrentIndex = index;
                                                });
                                              },
                                            )
                                          ),
                                        ),
                                        Container(
                                          child: Column(
                                            spacing: 16,
                                            children: [
                                              IntrinsicHeight(
                                                child: Row(
                                                  spacing: 8,
                                                  children: [
                                                    IntrinsicWidth(
                                                      child: Custom_Dropdown(
                                                        valueListenable_title: valueListenable_dailyPeroid,
                                                        List_items: dailyPeroid,
                                                        onChanged: (vale) {
                                                          setState(() {
                                                            dailyBarTouchCurrentIndex = 0;
                                                            dailyPeroidSelected = ChartPeriod.fromEntity(vale);
                                                          });
                                                        },
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: DetailScoreBar(
                                                        score: curentData.$2,
                                                        date: curentData.$1,
                                                        dateFormated: (date) => dateFormatDetail(date),
                                                      )
                                                    )
                                                  ],
                                                ),
                                              ),
                                              DetailBox(
                                                icon: change != null 
                                                  ? change > 0 ? LucideIcons.trendingUp : LucideIcons.trendingDown
                                                  : LucideIcons.minus,
                                                title: "Change",
                                                content: change == null 
                                                  ? '--' 
                                                  : "${change.toStringAsFixed(1)} scores, ${changePercent!.toStringAsFixed(2)}% change",
                                                contentColor: change != null 
                                                  ? change > 0 ? AppColor.green1 : AppColor.red1
                                                  : null,
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          );
                        }()
                    
                    ]
                  ]
                ),
              ),
            ),
          ],
        ),
      )
    );
  }
}