import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flexiback/features/profile/domain/entities/profile_entity.dart';
import 'package:flexiback/features/profile/presentation/controller/profile_provider.dart';
import 'package:flexiback/features/profile/presentation/widgets/dropdown.dart';
import 'package:flexiback/features/profile/presentation/widgets/edit_box.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';

import '../../../../shared/theme/colors/app_color.dart';
import '../../../../shared/utils/text_uppercase.dart';
import '../../domain/entities/general_entity.dart';
import '../widgets/edit_box_part.dart';
import '../widgets/edit_feild.dart';
import '../widgets/edit_head_part.dart';
import '../widgets/pill_feild.dart';
import '../widgets/profile_img.dart';

class GeneralEdit extends StatefulWidget {
  GeneralEdit({super.key});

  @override
  State<GeneralEdit> createState() => _GeneralEditState();
}

class _GeneralEditState extends State<GeneralEdit> {
  GeneralEntity? newProfile;

  final List<String> title_list = ["-","Mr","Ms.","Miss","Mrs.","Dr.","Prof.","Rev."];
  late ValueNotifier<String?> valueListenable_title;

  final List<String> gender_list = ["-","Male","Female","Other","Croissant"];
  late ValueNotifier<String?> valueListenable_gender;

  @override
  void dispose() {
    valueListenable_title.dispose();
    valueListenable_gender.dispose();
    newProfile = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profileProvider = context.watch<ProfileProvider>();
    newProfile = (profileProvider.profile as GeneralEntity).getProfileData;

    valueListenable_title = ValueNotifier<String?>(newProfile!.title ?? title_list[0]);
    valueListenable_gender = ValueNotifier<String?>(newProfile!.gender ?? gender_list[0]);

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
                      ProfileImg(),
                
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
                          onPressed: () {},
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
                            value: newProfile!.email,
                            keyboardType: TextInputType.emailAddress,
                            hint: "email address",
                            icon: LucideIcons.mail,
            
                            onChanged: (value) {
                              newProfile!.email = value;
                            },
                          ),
                          EditBoxPart(
                            title: "Phone",
                            value: newProfile!.number,
                            keyboardType: TextInputType.phone,
                            hint: "no phone number",
                            icon: LucideIcons.phone,
            
                            onChanged: (value) {
                              newProfile!.number = value;
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
                                    newProfile!.title = value;
                                  },
                                )
                              ),
                            ],
                          ),
            
                          Row(
                            spacing: 6,
                            children: [
                              Expanded(
                                child: EditFeild(
                                  value: newProfile!.firstName ?? "",
                                  hintText: "first name",
            
                                  onChanged: (value) {
                                    newProfile!.firstName = value;
                                  },
                                )
                              ),
            
                              Expanded(
                                child: EditFeild(
                                  value: newProfile!.lastName ?? "",
                                  hintText: "last name",
            
                                  onChanged: (value) {
                                    newProfile!.lastName = value;
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
                              newProfile!.gender = value;
                            }
                          )
                        ]
                      ),

                      EditHeadPart(
                        title: "body",
                        children: [
                          Wrap(
                            spacing: 8,       
                            runSpacing: 8,  
                            children: [
                              PillFeild(
                                title: "age",
                                value: newProfile!.age,
                                unit: null,
                                keyboardType: TextInputType.number,
                                onChanged: (value) {
                                  newProfile!.age = value;
                                },
                              ),

                              PillFeild(
                                title: "weight",
                                value: newProfile!.weight,
                                unit: "kg",
                                keyboardType: TextInputType.numberWithOptions(decimal: true),
                                onChanged: (value) {
                                  newProfile!.weight = value;
                                },
                              ),

                              PillFeild(
                                title: "height",
                                value: newProfile!.height,
                                unit: "cm",
                                keyboardType: TextInputType.number,
                                onChanged: (value) {
                                  newProfile!.height = value;
                                },
                              ),
                            ],
                          )
                        ]
                      )
                    ],
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