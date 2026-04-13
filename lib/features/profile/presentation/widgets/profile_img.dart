import 'package:flexiback/features/profile/presentation/controller/profile_provider.dart';
import 'package:flexiback/shared/theme/colors/app_color.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';

class ProfileImg extends StatelessWidget {
  ImageProvider? imageProvider;
  bool clickable;
  ProfileImg({
    super.key,
    required this.imageProvider,
    this.clickable = true
  });

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: () {
        if (!clickable || imageProvider == null) return;

        showDialog(
          context: context,
          builder: (context) {
            return Dialog(
              backgroundColor: AppColor.grey1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.zero
              ),
              insetPadding: EdgeInsets.symmetric(horizontal: 12),
              child: Image(
                image: imageProvider!,
                fit: BoxFit.cover,
              ),
            );
          }
        );

      },
      child: CircleAvatar(
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
      ),
    );
  }
}