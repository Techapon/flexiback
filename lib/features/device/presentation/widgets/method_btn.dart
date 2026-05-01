import 'package:flexiback/config/theme/colors/app_color.dart';
import 'package:flexiback/core/utils/text_uppercase.dart';
import 'package:flutter/material.dart';

class MethodBtn extends StatelessWidget {
  final String title;
  final Function onTap;
  const MethodBtn({
    super.key,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      style: FilledButton.styleFrom(
        backgroundColor: AppColor.base3,
        side: BorderSide(
          width: 1.5,
          color: AppColor.grey4,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      onPressed: () async {
        onTap();
      }, 
      child: Text(
        toFirstLetterUpper(title),
        style: TextStyle(
          color: AppColor.black1,
          fontSize: 14,
          fontWeight: FontWeight.bold
        ),
      )
    );
  }
}