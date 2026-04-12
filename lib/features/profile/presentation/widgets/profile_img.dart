import 'package:flexiback/features/profile/presentation/controller/profile_provider.dart';
import 'package:flexiback/shared/theme/colors/app_color.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';

class ProfileImg extends StatelessWidget {
  ImageProvider? imageProvider;
  ProfileImg({
    super.key,
    required this.imageProvider
  });

  @override
  Widget build(BuildContext context) {
    final profileProvider = context.watch<ProfileProvider>();

    return CircleAvatar(
      backgroundColor: AppColor.main2,
      radius: 70,
      child: CircleAvatar(
        radius: 67.5,
        backgroundColor: AppColor.base2,
        backgroundImage: imageProvider,
        child: imageProvider == null
            ? Icon(LucideIcons.user300, size: 75, color: AppColor.grey1)
            : null,
      )
    );
  }
}