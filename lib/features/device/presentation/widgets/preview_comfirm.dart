import 'package:fl_chart/fl_chart.dart';
import 'package:flexiback/config/theme/colors/app_color.dart';
import 'package:flexiback/features/device/presentation/controller/device_provider.dart';
import 'package:flexiback/features/device/presentation/widgets/gradient_button.dart';
import 'package:flexiback/features/device/presentation/widgets/preview_box.dart';
import 'package:flexiback/features/device/presentation/widgets/preview_percent_box.dart';
import 'package:flexiback/shared/widgets/dialog/error/dialog_error.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class PreviewComfirm extends StatefulWidget {
  const PreviewComfirm({super.key});

  @override
  State<PreviewComfirm> createState() => _PreviewComfirmState();
}

class _PreviewComfirmState extends State<PreviewComfirm> {
  
  @override
  Widget build(BuildContext context) {
    final deviceProvider = context.watch<DeviceProvider>();
    
    return Dialog(
      insetPadding: EdgeInsets.all(20),
      backgroundColor: AppColor.base1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(28)
      ),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: 26,
          vertical: 24
        ),
        child: Column(
          // spacing: 16,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            
            
            Column(
              spacing: 16,
              children: [

                // head
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  spacing: 4,
                  children: [
                    Text(
                      "Usage Data",
                      style: GoogleFonts.paytoneOne(
                        color: AppColor.black1,
                        fontSize: 26
                      ),
                    ),

                    Text(
                      "Date from 9:20 am. to 1:40pm on 24/4/2026.",
                      style: TextStyle(
                        color: AppColor.grey3,
                        fontSize: 12
                      ),
                    )
                  ],
                ),

                // Total time
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 18
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColor.blue3,
                        AppColor.blue4,
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    borderRadius: BorderRadius.circular(18)
                  ),
                  child: Column(
                    spacing: 8,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "total usage time".toUpperCase(),
                        style: TextStyle(
                          color: AppColor.base2.withOpacity(.7),
                          fontSize: 12,
                          fontWeight: FontWeight.bold
                        ),
                      ),

                      Row(
                        spacing: 16,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                            spacing: 4,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                deviceProvider.previewData!.totalHour,
                                style: GoogleFonts.paytoneOne(
                                  color: AppColor.base1,
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold,
                                  height: 1.07
                                ),
                              ),
                              Text(
                                "h.",
                                style: TextStyle(
                                  color: AppColor.base1.withOpacity(.7),
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                            ],
                          ),
                          
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            spacing: 4,
                            children: [
                              Text(
                                deviceProvider.previewData!.totalminute,
                                style: GoogleFonts.paytoneOne(
                                  color: AppColor.base1,
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold,
                                  height: 1.07
                                ),
                              ),
                              Text(
                                "m.",
                                style: TextStyle(
                                  color: AppColor.base1.withOpacity(.7),
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                ),

                Row(
                  spacing: 16,
                  children: [
                    Flexible(
                      flex: 1,
                      child: PreviewBox(
                        color: AppColor.green1,
                        title: "good posture",

                        time: deviceProvider.previewData!.goodTimeText,

                      )
                    ),

                    Flexible(
                      flex: 1,
                      child: PreviewBox(
                        color: AppColor.red1,
                        title: "bad posture",

                        time: deviceProvider.previewData!.badTimeText,

                      )
                    )
                  ],
                ),
              ],
            ),

            // Donut Chart
            SizedBox(
              height: 155,
              width: 155,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  PieChart(
                    PieChartData(
                      sectionsSpace: 0,
                      centerSpaceRadius: 60,
                      startDegreeOffset: 270,
                      sections: [
                        PieChartSectionData(
                          color: AppColor.green1,
                          value: deviceProvider.previewData!.goodPer,
                          radius: 17.5,
                          showTitle: false
                        ),
                        PieChartSectionData(
                          color: AppColor.grey1,
                          value: deviceProvider.previewData!.badPer,
                          radius: 17.5,
                          showTitle: false
                        )
                      ]
                    )
                  ),
              
                  Column(
                    spacing: 4,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        deviceProvider.previewData!.goodPerText,
                        style: TextStyle(
                          color: AppColor.black1,
                          fontSize: 20,
                          fontWeight: FontWeight.bold
                        ),
                      ),

                      Text(
                        "good posture \n rate".toUpperCase(),
                        style: TextStyle(
                          color: AppColor.grey3,
                          fontSize: 10
                        ),
                        textAlign: TextAlign.center,
                      )
                    ],
                  )
                ],
              ),
            ),

            Column(
              spacing: 16,
              children: [
                PreviewPercentBox(
                  color: AppColor.green1,
                  title: "good posture",
                  percent: int.parse(deviceProvider.previewData!.goodPerText),
                ),
                PreviewPercentBox(
                  color: AppColor.red1,
                  title: "bad posture",
                  percent: int.parse(deviceProvider.previewData!.badPerText),
                ),
              ],
            ),

            GradientButton(
              child: Text(
                !deviceProvider.isLoading 
                  ? "Confirm Dowload"
                  : "Loading ...",
                style: TextStyle(
                  color: AppColor.base1,
                  fontSize: 18,
                  fontWeight: FontWeight.bold
                ),
              ),
              onTap: () {
                if (deviceProvider.isLoading) return;
                print("Dowlaod full");

                if (deviceProvider.error != null && deviceProvider.fulldata != null) {
                  print("dowload success");
                } else {
                  showErrorDialog(
                    context: context,
                    message: deviceProvider?.error ?? "Data is empty,Please try again"
                  );
                }
              },
            )

          ],
        ),
      ),
    );
  }
}