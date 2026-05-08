import 'package:flexiback/config/theme/colors/app_color.dart';
import 'package:flexiback/core/entities/image_text_entity.dart';
import 'package:flexiback/features/trend/domain/enums/record_type.dart';
import 'package:flexiback/features/trend/presentation/controller/trend_provider.dart';
import 'package:flexiback/features/trend/presentation/widgets/detail_box.dart';
import 'package:flexiback/features/trend/presentation/widgets/graph/on_off/on_of_graph.dart';
import 'package:flexiback/features/trend/presentation/widgets/graph/pie/custom_pie_chart.dart';
import 'package:flexiback/features/trend/presentation/widgets/info_box.dart';
import 'package:flexiback/shared/widgets/appbar/appbar1.dart';
import 'package:flexiback/shared/widgets/status/loading/loading_status.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:lucide_icons_flutter/test_icons.dart';
import 'package:provider/provider.dart';

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

  late final TrendProvider _trendProvider;

  @override
  void initState() {
    super.initState();

    valueListenable_recordType = ValueNotifier(recordType[0].text);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _trendProvider = context.read<TrendProvider>();

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
            // Container(
            //   padding: EdgeInsets.symmetric(
            //     vertical: 7,
            //     horizontal: 16
            //   ),
            //   child: Row(
            //     spacing: 8,
            //     mainAxisAlignment: MainAxisAlignment.start,
            //     crossAxisAlignment: CrossAxisAlignment.center,
            //     children: [
            //       IconButton(
            //         style: IconButton.styleFrom(
            //           backgroundColor: AppColor.base1,
            //           elevation: 2,
            //           shadowColor: AppColor.black1.withOpacity(.2),
            //         ),
            //         onPressed: () {
            //           Navigator.pop(context);
            //         },
            //         icon: Icon(
            //           Icons.arrow_back_rounded,
            //           color: AppColor.black1,
            //           size: 36,
            //         )
            //       ),
            //       Row(
            //         spacing: 8,
            //         children: []
            //       ),
            //     ],
            //   ),
            // ),
            
            Padding(
              padding: EdgeInsets.only(
                left: 16,
                right: 16
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                // spacing: 16,
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
                              onTap: () {},
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
                      Column(
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
                            // color: Colors.grey.withOpacity(.2),
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
                      )
                    ],

                    if (recordTypeSelected == RecordType.dailyProgress) ...[
                      
                    ]
                  ]


                ],
              ),
            )
                
          ],
        ),
      )
    );
  }
}