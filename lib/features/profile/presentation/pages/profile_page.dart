import 'package:flexiback/features/profile/presentation/controller/profile_provider.dart';
import 'package:flexiback/features/profile/presentation/widgets/edit_btn.dart';
import 'package:flexiback/features/profile/presentation/widgets/profile_img.dart';
import 'package:flexiback/shared/theme/colors/app_color.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';

import '../../../../config/routes.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final profileProvider = context.watch<ProfileProvider>();

    if (profileProvider.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (profileProvider.profile == null) {
      return Scaffold(
        body: Center(
          child: Text(
            profileProvider.errorr ?? "User not found",
            style: TextStyle(
              fontSize: 16,
              color: AppColor.black1,
            ),
          ),
        ),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            // spacing: 16,
            children: [
              // header
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "MY PROFILE",
                      style: GoogleFonts.paytoneOne(
                        fontSize: 26,
                        wordSpacing: 4,
                        foreground: Paint()..shader = LinearGradient(
                          colors: [
                            AppColor.main1,
                            AppColor.main2,
                            AppColor.main3,
                            AppColor.main4,
                          ]
                        ).createShader(Rect.fromLTWH(0, 0, 100, 70))
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 18),

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

              SizedBox(height: 16),

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

              SizedBox(height: 24),

              EditBtn(
                onTap: () {
                  Navigator.pushNamed(context, AppRoutes.generalEdit);
                },
              )


            ],
          ),
        )
      ),
    );
  }
}