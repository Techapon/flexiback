import 'package:flexiback/features/profile/domain/entities/profile_entity.dart';
import 'package:flexiback/features/profile/domain/entities/therapist_entity.dart';
import 'package:flexiback/features/profile/presentation/controller/profile_provider.dart';
import 'package:flexiback/features/profile/presentation/widgets/card_field.dart';
import 'package:flexiback/features/profile/presentation/widgets/dropdown.dart';
import 'package:flexiback/features/profile/presentation/widgets/edit_box.dart';
import 'package:flexiback/features/profile/presentation/widgets/side_card_field.dart';
import 'package:flexiback/shared/utils/pick_img.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';

import '../../../../shared/entities/role_enum.dart';
import '../../../../shared/theme/colors/app_color.dart';
import '../../domain/entities/general_entity.dart';
import '../widgets/edit_box_part.dart';
import '../widgets/edit_field.dart';
import '../widgets/edit_head_part.dart';
import '../widgets/pill_field.dart';
import '../widgets/profile_img.dart';

class TherapistEdit extends StatefulWidget {
  TherapistEdit({super.key});

  @override
  State<TherapistEdit> createState() => _TherapistEditState();
}

class _TherapistEditState extends State<TherapistEdit> {
  TherapistEntity? therapistNewProfile;

  final List<String> title_list = ["-","Mr","Ms.","Miss","Mrs.","Dr.","Prof.","Rev."];
  late ValueNotifier<String?> valueListenable_title;

  final List<String> gender_list = ["-","Male","Female","Other","Croissant"];
  late ValueNotifier<String?> valueListenable_gender;

  @override
  void dispose() {
    valueListenable_title.dispose();
    valueListenable_gender.dispose();
    therapistNewProfile = null;
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    valueListenable_title = ValueNotifier(null);
    valueListenable_gender = ValueNotifier(null);
  }

  @override
  Widget build(BuildContext context) {
    final profileProvider = context.watch<ProfileProvider>();
    therapistNewProfile = (profileProvider.profile as TherapistEntity).getProfileData;

    valueListenable_title.value = therapistNewProfile!.title ?? title_list[0];
    valueListenable_gender.value = therapistNewProfile!.gender ?? gender_list[0];

    return Scaffold(
      backgroundColor: AppColor.base2,

      appBar: AppBar(
        backgroundColor: AppColor.base1,
        surfaceTintColor: AppColor.base1,
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
              onPressed: () {
                
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
                      // ProfileImg(
                        
                      // ),
                
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
                            // pickImage();
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
                            value: therapistNewProfile!.email,
                            keyboardType: TextInputType.emailAddress,
                            hint: "email address",
                            icon: LucideIcons.mail,
            
                            onChanged: (value) {
                              therapistNewProfile!.email = value;
                            },
                          ),
                          EditBoxPart(
                            title: "Phone",
                            value: therapistNewProfile!.number,
                            keyboardType: TextInputType.phone,
                            hint: "no phone number",
                            icon: LucideIcons.phone,
            
                            onChanged: (value) {
                              therapistNewProfile!.number = value;
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
                                    therapistNewProfile!.title = value;
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
                                  value: therapistNewProfile!.firstName ?? "",
                                  hintText: "first name",
            
                                  onChanged: (value) {
                                    therapistNewProfile!.firstName = value;
                                  },
                                )
                              ),
            
                              Expanded(
                                child: EditField(
                                  value: therapistNewProfile!.lastName ?? "",
                                  hintText: "last name",
            
                                  onChanged: (value) {
                                    therapistNewProfile!.lastName = value;
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
                              therapistNewProfile!.gender = value;
                            }
                          )
                        ]
                      ),

                      EditHeadPart(
                        title: therapistNewProfile is GeneralEntity ? "body" : "age",
                        children: [
                          Wrap(
                            spacing: 8,       
                            runSpacing: 8,  
                            children: [
                              PillField(
                                title: "age" ,
                                value: therapistNewProfile!.age,
                                unit: null,
                                keyboardType: TextInputType.number,
                                onChanged: (value) {
                                  therapistNewProfile!.age = value;
                                },
                              ),
                            ],
                          )
                        ]
                      )
                    ],
                  ),

                  EditBox(
                    title: "Medical Background",
                    children: [
                      EditHeadPart(
                        title: "Specialty and Affiliation",
                        children: [
                          CardField(
                            title: "Specialty",
                            icon: LucideIcons.userStar500,
                            hintText: '-',
                            value: therapistNewProfile?.specialty,
                            onChanged: (String value) {
                              therapistNewProfile?.specialty = value;
                            },
                          ),
                          CardField(
                            title: "Affiliation",
                            icon: LucideIcons.hospital500,
                            hintText: '-',
                            value: therapistNewProfile?.affiliation,
                            onChanged: (value) {
                              therapistNewProfile?.affiliation = value;
                            },
                          ),
                        ]
                      ),

                      EditHeadPart(
                        title: "Educate",
                        children: [
                          SideCardField(
                            icon: LucideIcons.graduationCap500,
                            hintText: '-',
                            value: therapistNewProfile?.institution,
                            maxLine: 5,
                            maxLength: 150,
                            onChanged: (value) {
                              therapistNewProfile?.institution = value;
                            },
                          ),
                          
                        ]
                      ),

                      EditHeadPart(
                        title: "Experince",
                        children: [
                          EditField(
                            value: therapistNewProfile?.experience ?? "",
                            hintText: "-",
                            maxLine: 6,
                            maxLength: 200,
                            onChanged: (value) {
                              therapistNewProfile?.experience = value;
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