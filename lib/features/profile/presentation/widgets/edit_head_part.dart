import 'package:flutter/material.dart';

import '../../../../shared/theme/colors/app_color.dart';

class EditHeadPart extends StatelessWidget {

  final List<Widget> children;
  final String title;
  const EditHeadPart({
    super.key, 
    required this.title, 
    required this.children
  });


  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 8,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: AppColor.grey4,
            fontWeight: FontWeight.bold,
            fontSize: 14
          ),
        ),
        ...children,
      ],
    );
  }
}