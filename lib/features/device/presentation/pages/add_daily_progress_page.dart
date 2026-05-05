import 'package:dotted_border/dotted_border.dart';
import 'package:flexiback/config/theme/colors/app_color.dart';
import 'package:flexiback/core/entities/image_entity.dart';
import 'package:flexiback/features/device/domain/entities/daily_progress_entity.dart';
import 'package:flexiback/features/device/presentation/controller/daily_progress_provider.dart';
import 'package:flexiback/features/device/presentation/controller/device_provider.dart';
import 'package:flexiback/features/device/presentation/widgets/daily_card_view.dart';
import 'package:flexiback/features/device/presentation/widgets/daily_crad.dart';
import 'package:flexiback/shared/widgets/general/gradient_button.dart';
import 'package:flexiback/shared/helpers/pick_img.dart';
import 'package:flexiback/shared/widgets/appbar/appbar1.dart';
import 'package:flexiback/shared/widgets/dialog/comfirm/dialog_comfirm.dart';
import 'package:flexiback/shared/widgets/dialog/error/dialog_error.dart';
import 'package:flexiback/shared/widgets/dialog/success/dialog_success.dart';
import 'package:flexiback/shared/widgets/dialog/warn/dislog_warn.dart';
import 'package:flexiback/shared/widgets/form/edit_field.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';

class AddDailyProgressPage extends StatefulWidget {
  const AddDailyProgressPage({super.key});

  @override
  State<AddDailyProgressPage> createState() => _AddDailyProgressPageState();
}

class _AddDailyProgressPageState extends State<AddDailyProgressPage> {
  bool addingDailyProgress = false;

  ImageEntity? addImage;

  String? errorText;

  final TextEditingController noteC = TextEditingController();

  late DeviceProvider _deviceProvider;

  // picker Image
  Future<void> pickerImage() async {
    final file = await pickImageGallery();

    if (file == null) return;

    setState(() {
      addImage = file;
    });
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _deviceProvider = context.read<DeviceProvider>();
      }
    });
  }

  @override
  void dispose() {
    if (_deviceProvider.runtimeType.toString() != 'late DeviceProvider') {
      _deviceProvider.stopListening();
    }
    errorText = null;
    addImage = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dailyProgressProvider = context.watch<DailyProgressProvider>();
    final deviceProvider = context.watch<DeviceProvider>();
    
    return PopScope(
      canPop: !dailyProgressProvider.isLoading,
      child: Scaffold(
        appBar: Appbar1(title: "daily progress"),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
            ),
            child: SingleChildScrollView(
              child: Column(
                spacing: 16,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
              
                  GestureDetector(
                    onTap: () {
                      if (addingDailyProgress) return;
                      addingDailyProgress = true;
                      
                      setState(() {});
                    },
                    child: DottedBorder(
                        color: !addingDailyProgress ? AppColor.grey2 : Colors.transparent,    
                        strokeWidth: !addingDailyProgress ? 1.5 : 0,       
                        dashPattern: [8, 4],  
                        borderType: BorderType.RRect,
                        radius: Radius.circular(18),
                        child: Stack(
                          children: [
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(vertical: 32,horizontal: !addingDailyProgress ? 16 : 24),
                              decoration: BoxDecoration(
                                color: !addingDailyProgress ? Colors.transparent : AppColor.base2,
                                borderRadius: BorderRadius.circular(24),
                                border: !addingDailyProgress
                                  ? null
                                  : Border.all(
                                      color: AppColor.grey2,
                                      width: 2
                                    )
                              ),
                              child: Column(
                                spacing: !addingDailyProgress ? 8 : 16,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  
                                  if (!addingDailyProgress) ...[
                                    Icon(
                                      Icons.add_a_photo_outlined,
                                      color: AppColor.grey2,
                                      size: 40,
                                    ),
                                                
                                    Text(
                                      "Add daily progress",
                                      style: GoogleFonts.paytoneOne(
                                        color: AppColor.black1,
                                        fontSize: 16,
                                      ),
                                    ),
                                                
                                    Text(
                                      "Record your progress to see your improvement",
                                      style: TextStyle(
                                        color: AppColor.grey3,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold
                                      ),
                                    )
                                  ],
                                        
                                  if (addingDailyProgress) ...[
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Flexible(
                                          child: GestureDetector(
                                            onTap: () {
                                              pickerImage();
                                            },
                                            child: Container(
                                              width: addImage == null ? 190 : null,
                                              height: 250,
                                              clipBehavior: Clip.antiAlias,
                                              decoration: BoxDecoration(
                                                color: AppColor.grey1,
                                                borderRadius: BorderRadius.circular(14),
                                                border: Border.all(
                                                  color: AppColor.grey3,
                                                  width: 2
                                                )
                                              ),
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.circular(12),
                                                child: addImage == null 
                                                ? Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Icon(
                                                      LucideIcons.imagePlus300,
                                                      size: 36,
                                                      color: AppColor.grey3,
                                                    ),
                                                    SizedBox(height: 8,),
                                                    Text(
                                                      "Upload Image",
                                                      style: TextStyle(
                                                        color: AppColor.grey4,
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.bold
                                                      ),
                                                    ),
                                                    Text(
                                                      "take a photo and put it here",
                                                      style: TextStyle(
                                                        color: AppColor.grey3,
                                                        fontSize: 12,
                                                        fontWeight: FontWeight.bold
                                                      ),
                                                    ),
                                                  ],
                                                )
                                                : Image.file(
                                                  addImage!.file!,
                                                  fit: BoxFit.fitHeight,
                                                  frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                                                    if (wasSynchronouslyLoaded) return child;
                                                
                                                    if (frame == null) {
                                                      return Center(
                                                        child: SizedBox(
                                                          width: 30,
                                                          height: 30,
                                                          child: CircularProgressIndicator(
                                                            strokeWidth: 2,
                                                            color: AppColor.base1,
                                                          ),
                                                        ),
                                                      );
                                                    }
                                                
                                                    return AnimatedOpacity(
                                                      opacity: 1,
                                                      duration: Duration(milliseconds: 500),
                                                      curve: Curves.easeOut,
                                                      child: child,
                                                    );
                                                  },
                                                )
                                                ,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                        
                                    Divider(color: AppColor.grey2,),
                                        
                                    Column(
                                      spacing: 8,
                                      children: [
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          spacing: 8,
                                          children: [
                                            Text(
                                              "Straight Score : ",
                                              style: TextStyle(
                                                color: AppColor.black1,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold
                                              ),
                                            ),

                                            if (deviceProvider.isLoadingData || deviceProvider.realTimeData != null) 
                                              Text(
                                                "${deviceProvider.realTimeData?["CH2"] ?? '0' }",
                                                style: TextStyle(
                                                  color: AppColor.grey4,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold
                                                ),
                                              ),

                                              TextButton(
                                                style: TextButton.styleFrom(
                                                  foregroundColor: AppColor.base1,
                                                  backgroundColor: AppColor.grey1,

                                                  padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                                                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                                  minimumSize: Size.zero,
                                      
                                                ),
                                                onPressed: () {
                                                  if (!deviceProvider.isConnected) return;
                                                  if (!deviceProvider.isLoadingData) {
                                                    deviceProvider.getRealTimeData();
                                                  } else {
                                                    deviceProvider.stopListening();
                                                  }
                                                }, 
                                                child: Text(
                                                  !deviceProvider.isLoadingData ? "START" : 'STOP',
                                                  style: TextStyle(
                                                    color: AppColor.black1,
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold
                                                  ),
                                                )
                                              ),
                                          ],
                                        ),
                                        
                                        Column(
                                          spacing: 8,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Note",
                                              style: TextStyle(
                                                color: AppColor.black1,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold
                                              ),
                                            ),
                                            
                                            EditField(
                                              value: "",
                                              hintText: "What would you like to say to yourself in the future?",
                                              onChanged: (value) {
                                                noteC.text = value;
                                              },
                                              maxLine: 5,
                                              maxLength: 100,
                                              firstUpper: false,
                                            )
                                          ],
                                        ),
                                      ],
                                    ),

                                    if (errorText != null)
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            "* ${errorText!}",
                                            style: TextStyle(
                                              color: AppColor.error,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold
                                            ),
                                          ),
                                        ],
                                      ),
      
                                    GradientButton(
                                      disable: !deviceProvider.isConnected,
                                      onTap: () async {
                                        if (dailyProgressProvider.isLoading || !deviceProvider.isConnected) return;
                                        errorText = null;
                                        if (addImage == null) {
                                          errorText = "Please upload your image";
                                          setState(() {});
                                          return;
                                        }
                                        await dailyProgressProvider.addDailyProgress(
                                          DailyProgressEntity(
                                            img: "",
                                            straightScore: deviceProvider.realTimeData?["CH2"]as double,
                                            note: noteC.text,
                                          ),
                                          addImage! 
                                        );
      
                                        if (dailyProgressProvider.error == null) {
                                          showSuccessDialog(context: context, message: "Add daily progress success!");
                                          addingDailyProgress = false;
                                          setState(() {});
                                        } else {
                                          showErrorDialog(context: context, message: dailyProgressProvider.error!);
                                        }
                                      },
                                      child: Text(
                                        deviceProvider.isConnected
                                          ? dailyProgressProvider.isLoading
                                            ? "Uploading..."
                                            : "Add Daily Progress"
                                          : 'You need to connect to device',
                                        style: TextStyle(
                                          color:AppColor.base1,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold
                                        ),
                                      )
                                    )
                                  ]
                                ],
                              ),
                            ),
      
                            if (addingDailyProgress && !dailyProgressProvider.isLoading)
                              Positioned(
                                right: 0,
                                child: IconButton(
                                  style: IconButton.styleFrom(
                                    foregroundColor: AppColor.grey3
                                  ),
                                  onPressed: () {
                                    addingDailyProgress = false;
                                    addImage = null;
                                    noteC.text = "";
                                    setState(() {});
                                  },
                                  icon: Icon(
                                    LucideIcons.x500,
                                    color: AppColor.grey3,
                                    size: 22,
                                  )
                                ),
                              )
                          ],
                        )
                    ),
                  ),

                  if (dailyProgressProvider.dailyStream != null)
                    StreamBuilder(
                      stream: dailyProgressProvider.dailyStream,
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Center(child: CircularProgressIndicator());
                        }

                        if (snapshot.hasError) {
                          return Center(child: Text("Error: ${snapshot.error}"));
                        }

                        final data = snapshot.data!;
                        
                        if (data.isEmpty) {
                          return Center(child: Text("No data here"));
                        }

                        return SizedBox(
                          height: 410,
                          child: ListView.separated(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            separatorBuilder: (context, index) => const SizedBox(width: 16),
                            itemCount: data.length,
                            itemBuilder: (context, index) {
                              final item = data[index];
                              return DailyCard(
                                item: item,
                                ontap: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return DailyCardView(
                                        item: item,
                                        onTapBin: () {
                                          showComfirmDialog(
                                            context: context,
                                            title: "Delete Daily Progress",
                                            message: "Are you sure you want to delete it?",

                                            comfirm: "Yes, Delete!",
                                            cancel: "No",

                                            onConfirm: () async {
                                              await dailyProgressProvider.deleteDailyProgress(item.id!);
                                              Navigator.pop(context);
                                              if (dailyProgressProvider.error == null) {
                                                if (context.mounted) {
                                                  Navigator.pop(context); // Close dialog
                                                  showSuccessDialog(context: context, message: "Delete daily progress success!");
                                                }
                                              } else {
                                                if (context.mounted) {
                                                  showErrorDialog(context: context, message: dailyProgressProvider.error!);
                                                }
                                              }
                                            }
                                          );
                                        },
                                      );
                                    }
                                  );
                                },
                              );
                            },
                          ),
                        );
                      }
                    )
                ],
              ),
            )
          )
        ),
      ),
    );
  }
}