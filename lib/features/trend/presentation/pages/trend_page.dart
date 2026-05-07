import 'dart:ui';

import 'package:flexiback/config/theme/colors/app_color.dart';
import 'package:flexiback/core/utils/text_from_percent.dart';
import 'package:flexiback/features/trend/presentation/controller/trend_provider.dart';
import 'package:flexiback/features/trend/presentation/widgets/percent_box.dart';
import 'package:flexiback/shared/widgets/appbar/appbar1.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class TrendPage extends StatefulWidget {
  final String? userId;
  const TrendPage({
    super.key,
    this.userId
  });

  @override
  State<TrendPage> createState() => _TrendPageState();
}

class _TrendPageState extends State<TrendPage> {
  late final TrendProvider _trendProvider;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _trendProvider = context.read<TrendProvider>();
      _trendProvider.getOverviewData(widget.userId!);
    });
  }

  @override
  void dispose() {
    _trendProvider.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final TrendProvider trendProvider = context.watch<TrendProvider>();

  //   final _dates = <DateTime>[
  //   DateTime(2026,05,5),
  //   DateTime(2026,05,8),
  //   DateTime(2026,05,29),
  // ];

    return Scaffold(
      appBar: Appbar1(
        title: "Progress",
        pathImag: "assets/emoji/graph.png",
      ),
      body: SingleChildScrollView(
        child: StreamBuilder(
          stream: trendProvider.overviewStream,
          builder: (context, snapshot) {
      
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
      
            if (snapshot.hasError) {
              return Center(
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.75,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      spacing: 4,
                      children: [
                        Icon(
                          LucideIcons.triangleAlert,
                          color: AppColor.error,
                          size: 50,
                        ),
                        Text(
                          "${trendProvider.error}",
                          style: TextStyle(
                            color: AppColor.black1,
                            fontSize: 16,
                            fontWeight: FontWeight.bold
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }
      
            if (!snapshot.hasData) {
              return Center(
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.75,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      spacing: 4,
                      children: [
                        Icon(
                          LucideIcons.triangleAlert,
                          color: AppColor.error,
                          size: 50,
                        ),
                        Text(
                          "Some thing went wrong, \n Please try again.",
                          style: TextStyle(
                            color: AppColor.black1,
                            fontSize: 16,
                            fontWeight: FontWeight.bold
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }

            List<DateTime?> _usageDates = trendProvider.deviceOverviewList!.map(
              (overview) => overview.dateTime
            ).toList();
            
            late DateTime first;
            late DateTime focus;
            late DateTime last;

            if (_usageDates.isNotEmpty) {
              _usageDates.sort((a,b) => a!.compareTo(b!));
              first = _usageDates.first!;
              focus = _usageDates.last!;
              last = _usageDates.last!;
            } else {
              first = DateTime(DateTime.now().year,DateTime.now().month,1);
              focus = DateTime(DateTime.now().year,DateTime.now().month,1);
              last = DateTime(DateTime.now().year,DateTime.now().month,30);
            }
      
            return Column(
              spacing: 16,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    left: 16,
                    right: 16,
                  ),
                  child: Column(
                    spacing: 16,
                    children: [
      
                      Container(
                        padding: EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(28),
                          gradient: LinearGradient(colors: AppColor.mainGradientColrs)
                        ),
                        child: Column(
                          spacing: 10,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  spacing: 8,
                                  children: [
                                    Container(
                                      clipBehavior: Clip.antiAlias,
                                      padding: EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8)
                                      ),
                                      child: BackdropFilter(
                                        filter:  ImageFilter.blur(
                                          sigmaX: 35,
                                          sigmaY: 35
                                        ),
                                        child: Icon(
                                          LucideIcons.clock8,
                                          color: AppColor.base1,
                                          size: 20,
                                        ),
                                      ),
                                    ),
            
                                    Text(
                                      "TOTAL USAGE",
                                      style: GoogleFonts.paytoneOne(
                                        color: AppColor.base1.withOpacity(.5),
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold
                                      ),
                                    )
                                  ],
                                ),
            
                                FilledButton(
                                  style: FilledButton.styleFrom(
                                    backgroundColor: AppColor.base1, 
                                    foregroundColor:AppColor.grey1,
                                    elevation: 4,                 
                                    shadowColor: AppColor.base3.withOpacity(0.5),
            
                                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                    minimumSize: Size.zero,
                                    padding: EdgeInsets.symmetric(vertical: 4,horizontal: 24),
                                  ),
                                  onPressed: () {},
                                  child: ShaderMask(
                                    blendMode: BlendMode.srcIn, 
                                    shaderCallback: (Rect bounds) {
                                      return LinearGradient(
                                        colors: AppColor.mainGradientColrs,
                                      ).createShader(bounds); 
                                    },
                                    child: Text(
                                      "more",
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  )
                                )
                              ],
                            ),
            
                            Row(
                              spacing: 8,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Row(
                                  spacing: 4,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      "${trendProvider.overviewData!.totalHours}",
                                      style: GoogleFonts.paytoneOne(
                                        color: AppColor.base1,
                                        fontSize: 65,
                                        fontWeight: FontWeight.bold,
                                        height: .7
                                      ),
                                    ),
                                    Text(
                                      ": ${trendProvider.overviewData!.totalMinutes.toString().padLeft(2,'0')}",
                                      style: GoogleFonts.paytoneOne(
                                        color: AppColor.base1,
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold,
                                        height: .5
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  "HOURS",
                                  style: GoogleFonts.paytoneOne(
                                    color: AppColor.base1.withOpacity(.7),
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                    height: .5
                                  ),
                                )
                              ],
                            ),
                            
                            SizedBox(height: 4,),
            
                            Padding(
                              padding: EdgeInsets.only(right: 32),
                              child: LinearProgressIndicator(
                                value: trendProvider.overviewData!.goodPercentage! / 100 ,
                                backgroundColor: AppColor.base1.withOpacity(.4),
                                valueColor: AlwaysStoppedAnimation<Color>(AppColor.base1),
                                minHeight: 5,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
            
                            Text(
                              "Accumulated since the device was first used",
                              style: TextStyle(
                                fontStyle: FontStyle.italic,
                                color: AppColor.base1.withOpacity(.5),
                                fontSize: 14,
                                fontWeight: FontWeight.bold
                              ),
                            )
                          ],
                        ),
                      ),
                      IntrinsicHeight(
                        child: Row(
                          spacing: 8,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Flexible(
                              flex: 1,
                              child: PercentBox(
                                title: 'Good posture',
                                color: AppColor.success,
                                icon: LucideIcons.circleCheck400,
                                percent: trendProvider.overviewData!.goodPercentage!.round(),
                                commentText: textGoodFromPercent(trendProvider.overviewData!.goodPercentage!.round()),
                              )
                            ),
            
                            Flexible(
                              flex: 1,
                              child: PercentBox(
                                title: 'Bad posture',
                                color: AppColor.error,
                                icon: LucideIcons.circleX400,
                                percent: trendProvider.overviewData!.badPercentage!.round(),
                                commentText: textBadFromPercent(trendProvider.overviewData!.badPercentage!.round()),
                              )
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
      
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: AppColor.base1,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: AppColor.black1.withOpacity(.2),
                        offset: Offset(0, 0),
                        blurRadius: 12,
                        spreadRadius : 0
                      )
                    ]
                  ),
                  child: TableCalendar(
                    firstDay: first,
                    lastDay: last,
                    focusedDay: focus,
                  
                    selectedDayPredicate: (day) {
                      return _usageDates.any((dayinList) => isSameDay(dayinList, day));
                    },
                  
                    onDaySelected:(selectedDay, focusedDay) {
                      bool isInSelected = _usageDates.any((dayinList) => isSameDay(dayinList, selectedDay));
                  
                      isInSelected ? print(selectedDay) : null;
                    },

                    headerStyle: HeaderStyle(
                      formatButtonVisible: false, 
                      titleCentered: false,
                      headerMargin: EdgeInsets.zero,
                      titleTextStyle: TextStyle(color: AppColor.grey4, fontSize: 16, fontWeight: FontWeight.bold),
                      leftChevronIcon: Icon(Icons.arrow_back_ios, color: AppColor.grey4, size: 14),
                      rightChevronIcon: Icon(Icons.arrow_forward_ios, color: AppColor.grey4, size: 14),
                      decoration: BoxDecoration(
                        color: AppColor.base1,
                        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                      ),
                    ),
                  
                    calendarStyle: CalendarStyle(
                      outsideDaysVisible: false,
                      defaultTextStyle: TextStyle(color: AppColor.black1,fontWeight: FontWeight.bold,fontSize: 14),

                      todayTextStyle: TextStyle(color: AppColor.black1,fontWeight: FontWeight.bold,fontSize: 14),
                      todayDecoration: BoxDecoration(
                        color: AppColor.main2.withOpacity(0),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: AppColor.main2,
                          width: 1.5
                        )
                      ),
                      selectedDecoration: BoxDecoration(
                        color: AppColor.main2,
                        borderRadius: BorderRadius.circular(8),
                      ),

                      weekendTextStyle:TextStyle(color: AppColor.black1,fontWeight: FontWeight.bold,fontSize: 14),
                    ),

                    calendarBuilders: CalendarBuilders(
                      dowBuilder: (context, day) {
                        final text = DateFormat.E('en_US').format(day).substring(0,1); 

                        return Center(
                          child: Text(
                            text,
                            style: TextStyle(
                              color: AppColor.grey4,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        );
                      },
                    ),

                    
                  ),
                ),

                SizedBox(height: 96,)
              ],
            );
          }
        ),
      )
    );
  }
}