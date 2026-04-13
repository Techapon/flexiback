import 'dart:io';

import 'package:flexiback/features/profile/presentation/controller/profile_provider.dart';
import 'package:flexiback/features/profile/presentation/widgets/dropdown.dart';
import 'package:flexiback/features/profile/presentation/widgets/edit_box.dart';
import 'package:flexiback/shared/entities/image_entity.dart';
import 'package:flexiback/shared/utils/pick_img.dart';
import 'package:flexiback/shared/widgets/dialog/success/dialog_success.dart';
import 'package:flexiback/shared/widgets/status/error/error_status.dart';
import 'package:flexiback/shared/widgets/status/loading/loading_status.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';

import '../../../../shared/theme/colors/app_color.dart';
import '../../domain/entities/general_entity.dart';
import '../widgets/edit_box_part.dart';
import '../widgets/edit_field.dart';
import '../widgets/edit_head_part.dart';
import '../widgets/pill_field.dart';
import '../widgets/profile_img.dart';

class GeneralEdit extends StatefulWidget {
  GeneralEdit({super.key});

  @override
  State<GeneralEdit> createState() => _GeneralEditState();
}

class _GeneralEditState extends State<GeneralEdit> {
  GeneralEntity? generalNewProfile;

  ImageEntity? newImage;
  
  final List<String> title_list = ["-","Mr","Ms.","Miss","Mrs.","Dr.","Prof.","Rev."];
  late ValueNotifier<String?> valueListenable_title;

  final List<String> gender_list = ["-","Male","Female","Other","Croissant"];
  late ValueNotifier<String?> valueListenable_gender;

  // picker Image
  Future<void> pickerImage() async {
    final file = await pickImageGallery();

    if (file == null) return;

    setState(() {
      newImage = file;
    });

  }

  @override
  void initState() {
    super.initState();
    valueListenable_title = ValueNotifier(null);
    valueListenable_gender = ValueNotifier(null);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final profileProvider = context.read<ProfileProvider>();
      generalNewProfile = (profileProvider.profile as GeneralEntity).getProfileData;
      valueListenable_title.value = generalNewProfile!.title ?? title_list[0];
      valueListenable_gender.value = generalNewProfile!.gender ?? gender_list[0];
      setState(() {});
    });
  }

  @override
  void dispose() {
    generalNewProfile = null;
    newImage = null;
    valueListenable_title.dispose();
    valueListenable_gender.dispose();
    super.dispose();
  }

  


  @override
  Widget build(BuildContext context) {
    final profileProvider = context.watch<ProfileProvider>();

    if (profileProvider.isLoading || generalNewProfile == null) {
      return LoadingStatus(text: "Updating Profile ...",);
    }

    if (profileProvider.profile == null) {
      return ErrorStatus(text: profileProvider.error);
    }

    ImageProvider? imageProvider = null;

    if (newImage?.file != null) {
      imageProvider = FileImage(newImage!.file!);
    } else if (generalNewProfile!.img != null) {
      imageProvider = NetworkImage(generalNewProfile!.img!);
    }

    return Scaffold(
      backgroundColor: AppColor.base2,

      appBar: AppBar(
        backgroundColor: AppColor.base1,
        elevation: 0,
        leading: IconButton(
          icon: Icon(LucideIcons.arrowLeft),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 8),
            child: IconButton(
              icon: Icon(LucideIcons.check,color: AppColor.success,),
              splashColor: AppColor.success,
              focusColor: AppColor.success,
              hoverColor: AppColor.success,
              onPressed: () async {
                if (profileProvider.isLoading) return;
                await profileProvider.updateProfile(
                  generalNewProfile!,
                  newImage
                );

                if (profileProvider.error == null) {
                  showSuccessDialog(
                    context: context,
                    message: "Update profile success!!",
                  );
                }
              },
            ),
          ),
        ],
        title: Text(
          "Profile Edit",
          style: TextStyle(
            color: AppColor.black1,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 36,vertical: 24),
            child: Container(
              width: double.infinity,
              child: Column(
                spacing: 24,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  
                  Stack(
                    children: [
                      ProfileImg(
                        imageProvider: imageProvider,
                      ),

                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: IconButton(
                          style: IconButton.styleFrom(
                            backgroundColor: AppColor.main2,
                            shape: CircleBorder(),
                            padding: EdgeInsets.all(10),
                            side: BorderSide(
                              color: AppColor.base1,
                              width: 2
                            )
                          ),
                          onPressed: () {
                            pickerImage();
                          },
                          icon: Icon(LucideIcons.camera, size: 18, color: AppColor.base1),
                        )
                      )
                    ],
                  ),
            
                  EditBox(
                    title: "Account",
                    children: [
                      Column(
                        spacing: 8,
                        children: [
                          EditBoxPart(
                            title: "Email",
                            value: generalNewProfile!.email,
                            keyboardType: TextInputType.emailAddress,
                            hint: "email address",
                            icon: LucideIcons.mail,
                            readOnly: true,
            
                            onChanged: (value) {
                              generalNewProfile!.email = value;
                            },
                          ),
                          EditBoxPart(
                            title: "Phone",
                            value: generalNewProfile!.number,
                            keyboardType: TextInputType.phone,
                            hint: "no phone number",
                            icon: LucideIcons.phone,
            
                            onChanged: (value) {
                              generalNewProfile!.number = value;
                            },
                          ),
                        ],
                      )
                    ],
                  ),
            
                  EditBox(
                    title: "Personal",
                    children: [
                      EditHeadPart(
                        title: "name",
                        children: [
                          Row(
                            spacing: 6,
                            children: [
                              Expanded(
                                child: Custom_Dropdown(
                                  valueListenable_title: valueListenable_title,
                                  List_items: title_list,
            
                                  onChanged: (value) {
                                    generalNewProfile!.title = value;
                                  },
                                )
                              ),
                            ],
                          ),
            
                          Row(
                            spacing: 6,
                            children: [
                              Expanded(
                                child: EditField(
                                  value: generalNewProfile!.firstName ?? "",
                                  hintText: "first name",
            
                                  onChanged: (value) {
                                    generalNewProfile!.firstName = value;
                                    // print("NAME : ${generalNewProfile!.firstName}");
                                  },
                                )
                              ),
            
                              Expanded(
                                child: EditField(
                                  value: generalNewProfile!.lastName ?? "",
                                  hintText: "last name",
            
                                  onChanged: (value) {
                                    generalNewProfile!.lastName = value;
                                  },
                                )
                              ),
                            ],
                          )
                      
                        ],
                      ),
                      
                      EditHeadPart(
                        title: "gender",
                        children: [
                          Custom_Dropdown(
                            valueListenable_title: valueListenable_gender,
                            List_items: gender_list,
                            onChanged: (value) {
                              generalNewProfile!.gender = value;
                            }
                          )
                        ]
                      ),

                      EditHeadPart(
                        title: generalNewProfile is GeneralEntity ? "body" : "age",
                        children: [
                          Wrap(
                            spacing: 8,       
                            runSpacing: 8,  
                            children: [
                              PillField(
                                title: "age" ,
                                value: generalNewProfile!.age,
                                unit: null,
                                keyboardType: TextInputType.number,
                                onChanged: (value) {
                                  generalNewProfile!.age = value;
                                },
                              ),
                              PillField(
                                title: "weight",
                                value: generalNewProfile?.weight,
                                unit: "kg",
                                keyboardType: TextInputType.numberWithOptions(decimal: true),
                                onChanged: (value) {
                                  generalNewProfile?.weight = value;
                                },
                              ),
                              PillField(
                                title: "height",
                                value: generalNewProfile?.height,
                                unit: "cm",
                                keyboardType: TextInputType.number,
                                onChanged: (value) {
                                  generalNewProfile?.height = value;
                                },
                              ),
                            ],
                          )
                        ]
                      )
                    ],
                  ),

                  EditBox(
                    title: "Medical History",
                    children: [
                      EditHeadPart(
                        title: "past medical history",
                        children: [
                          EditField(
                            value: generalNewProfile?.pmh,
                            hintText: "-",
                            maxLine: 5,
                            maxLength: 150,
                            onChanged: (value) {
                              generalNewProfile?.pmh = value;
                            }
                          )
                        ]
                      )
                    ]
                  )
                ],
              ),
            )
          ),
        )
      )
      
    );
  }
}