import 'package:flexiback/config/theme/colors/app_color.dart';
import 'package:flutter/material.dart';

void ImageShowcase(BuildContext context,ImageProvider imageProvider) {
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
          image: imageProvider,
          fit: BoxFit.cover,
        ),
      );
    }
  );
}