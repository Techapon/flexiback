import 'package:flexiback/config/theme/colors/app_color.dart';
import 'package:flexiback/core/entities/image_text_entity.dart';
import 'package:flexiback/core/utils/month_getter.dart';
import 'package:flexiback/core/utils/week_getter.dart';
import 'package:flexiback/features/device/domain/entities/daily_progress_entity.dart';
import 'package:flexiback/features/trend/domain/enums/chart_period.dart';
import 'package:flexiback/features/trend/domain/enums/record_type.dart';
import 'package:flexiback/features/trend/domain/service/charts/aggegate_daily_progress.dart';
import 'package:flexiback/features/trend/domain/service/charts/fill_the_gap_day.dart';
import 'package:flexiback/features/trend/domain/service/charts/fill_the_gap_month.dart';
import 'package:flexiback/features/trend/domain/service/charts/divide_month.dart';
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
    ImageTextEntity(path: "assets/emoji/graph.png",text: RecordType.dailyProgress.entity, decorate: '')
  ];

  RecordType recordTypeSelected = RecordType.deviceUsage;


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
    valueListenable_dailyPeroid = ValueNotifier(dailyPeroid[0]);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _trendProvider = context.read<TrendProvider>();
      _trendProvider.getDailyProgress(widget.userId!);

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
                                  switch (recordTypeSelected) {
                                    case RecordType.deviceUsage:
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
                                      
                                    case RecordType.dailyProgress:
                                  }
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

                      if (recordTypeSelected == RecordType.deviceUsage) ...[
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
                            : change / currentOriginData.straightScore!;

                          // Group originData by month for the month view list
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
                                                        currentData:  curentData,
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

                        }()
                    ]
                  ],
                ),
              ),
            ),
          ],
        ),
      )
    );
  }
}