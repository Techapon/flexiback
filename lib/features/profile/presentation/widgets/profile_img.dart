import 'package:flexiback/config/theme/colors/app_color.dart';
import 'package:flexiback/shared/widgets/dialog/image_showcase/image_showcase.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

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

        ImageShowcase(context,imageProvider!);

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