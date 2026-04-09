import 'package:flexiback/features/profile/presentation/controller/profile_provider.dart';
import 'package:flexiback/shared/theme/colors/app_color.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';

class ProfileImg extends StatelessWidget {
  const ProfileImg({super.key});

  @override
  Widget build(BuildContext context) {
    final profileProvider = context.watch<ProfileProvider>();

    return CircleAvatar(
      backgroundColor: AppColor.main2,
      radius: 70,
      child: CircleAvatar(
        radius: 67.5,
        backgroundColor: AppColor.base2,
        backgroundImage: profileProvider.profile?.img != null
            ? NetworkImage(profileProvider.profile!.img!)
            : null,
        child: profileProvider.profile?.img == null
            ? Icon(LucideIcons.user300, size: 75, color: AppColor.grey1)
            : null,
      )
    );
  }
}