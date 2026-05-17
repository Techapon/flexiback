import 'package:flexiback/config/theme/colors/app_color.dart';
import 'package:flexiback/features/profile/domain/entities/therapist_entity.dart';
import 'package:flexiback/features/profile/presentation/widgets/profile_img.dart';
import 'package:flexiback/shared/widgets/appbar/appbar1.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../../core/utils/text_uppercase.dart';

class TherapistProfileView extends StatelessWidget {
  final TherapistEntity therapistProfile;
  const TherapistProfileView({
    super.key, 
    required this.therapistProfile
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Appbar1(title: "${
        therapistProfile.gender == null 
          ? '' 
          : therapistProfile.gender!.toLowerCase() == 'male' ? 'His' : 'Her'
      } Profile",getBack: true,),
      backgroundColor: AppColor.base1,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            top: 16,
            left: 16,
            right: 16,
          ),
          child: Column(
            spacing: 16,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
  
              ProfileImg(
                imageProvider: therapistProfile.img != null 
                  ? NetworkImage(therapistProfile.img!) 
                  : null,
                clickable:  true,
              ),

              Column(
                children: [
                   
                  Text(
                    therapistProfile.fullname,
                    style: TextStyle(
                      fontSize: 20,
                      color: AppColor.black1,
                      fontWeight: FontWeight.bold
                    ),
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 6,
                    children: [
                      Icon(LucideIcons.mail, size: 16, color: AppColor.grey3),
                      Text(
                        therapistProfile.email,
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColor.grey3,
                        ),
                      ),
                    ],
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 6,
                    children: [
                      Icon(LucideIcons.phone, size: 16, color: AppColor.grey3),
                      Text(
                        therapistProfile.getNumber,
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColor.grey3,
                        ),
                      ),
                    ],
                  ),
                ],
              ),


              Column(
                spacing: 2,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    spacing: 6,
                    children: [
                      Icon(
                        LucideIcons.user500,
                        color: AppColor.grey3,
                        size: 18,
                      ),
                      Text(
                        "${therapistProfile.gender}, ${therapistProfile.age} years old",
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColor.grey3,
                        ),
                      ),
                    ],
                  ),

                  Divider(color: AppColor.grey2,),
              
                  Row(
                    spacing: 8,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        LucideIcons.stethoscope500,
                        color: AppColor.blue1,
                        size: 18,
                      ),
                      Text(
                        "${therapistProfile.specialty ?? '-'}",
                        style: TextStyle(
                          color: AppColor.blue1,
                          fontSize: 16,
                          fontWeight: FontWeight.w900
                        ),
                      )
                    ],
                  ),

                  Row(
                    spacing: 8,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        LucideIcons.mapPin500,
                        color: AppColor.grey3,
                        size: 18,
                      ),
                      Text(
                        "${toFirstLetterUpper(therapistProfile.affiliation ?? '-')} ,Hospital",
                        style: TextStyle(
                          color: AppColor.grey3,
                          fontSize: 16
                        ),
                      )
                    ],
                  ),

                  Row(
                    spacing: 8,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        LucideIcons.graduationCap500,
                        color: AppColor.grey3,
                        size: 18,
                      ),
                      Text(
                        toFirstLetterUpper(therapistProfile.institution ?? '-'),
                        style: TextStyle(
                          color: AppColor.grey3,
                          fontSize: 16
                        ),
                      )
                    ],
                  ),

                  Divider(color: AppColor.grey2,),

                  Column(
                    spacing: 4,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "experince : ",
                        style: TextStyle(
                          color: AppColor.grey3,
                          fontSize: 16,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                      Text(
                        "       ${therapistProfile.experience}",
                        style: TextStyle(
                          color: AppColor.grey3,
                          fontSize: 16
                        ),
                        softWrap: true,
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  )
              
                ],
              ),
            ],
          ),
        )
      ),
    );
  }
}