import 'package:flexiback/features/profile/presentation/controller/profile_provider.dart';
import 'package:flexiback/features/profile/presentation/widgets/edit_btn.dart';
import 'package:flexiback/features/profile/presentation/widgets/profile_img.dart';
import 'package:flexiback/config/theme/colors/app_color.dart';
import 'package:flexiback/shared/widgets/appbar/appbar1.dart';
import 'package:flexiback/shared/widgets/status/error/error_status.dart';
import 'package:flexiback/shared/widgets/status/loading/loading_status.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';

import '../../../../config/router/routes.dart';
import '../../../../core/enums/role.dart';
import '../../../../core/utils/text_uppercase.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final profileProvider = context.watch<ProfileProvider>();

    if (profileProvider.isLoading) {
      return LoadingStatus(text: "Loading Profile ...",);
    }

    if (profileProvider.profile == null) {
      return ErrorStatus(text: profileProvider.error);
    }
    
    return Scaffold(
      appBar: Appbar1(
        title: "my profile",
        icon: LucideIcons.logOut500,
        action: () async {
          profileProvider.signOut();
              
          Navigator.pushNamed(context, AppRoutes.login);
        },
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
          ),
          child: Column(
            spacing: 16,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              ProfileImg(
                imageProvider: profileProvider.profile!.img != null 
                  ? NetworkImage(profileProvider.profile!.img!) 
                  : null,
                clickable:  true,
              ),

              Column(
                children: [
                  Text(
                    profileProvider.profile!.fullname,
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
                        profileProvider.profile!.email,
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
                        profileProvider.profile!.getNumber,
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColor.grey3,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              if (profileProvider.role == Role.Therapist)
                Column(
                  spacing: 2,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                
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
                          profileProvider.specialty,
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
                          "${toFirstLetterUpper(profileProvider.affiliation)} ,Hospital",
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
                          toFirstLetterUpper(profileProvider.institution),
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
                            fontSize: 14,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                        Text(
                          "       ${profileProvider.experience}",
                          style: TextStyle(
                            color: AppColor.grey3,
                            fontSize: 14
                          ),
                          softWrap: true,
                          maxLines: 4,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    )
                
                  ],
                ),

              EditBtn(
                onTap: () {
                  if (profileProvider.role == Role.General) {
                    Navigator.pushNamed(context, AppRoutes.generalEdit);
                  } else if (profileProvider.role == Role.Therapist) {
                    Navigator.pushNamed(context, AppRoutes.therapistEdit);
                  }
                },
              )
            ],
          ),
        )
      ),
    );
  }
}