import 'package:flutter/material.dart';

import '../../../../shared/theme/colors/app_color.dart';

class EditBox extends StatefulWidget {
  final List<Widget> children;
  final String title;
  const EditBox({
    super.key, 
    required this.title, 
    required this.children
  });

  @override
  State<EditBox> createState() => _EditBoxState();
}

class _EditBoxState extends State<EditBox> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColor.base1,
          border: Border.all(
            color: AppColor.grey2,
            width: 2
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          spacing: 16,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.title,
              style: TextStyle(
                color: AppColor.black1,
                fontWeight: FontWeight.bold,
                fontSize: 16
              ),
            ),
            ...widget.children,
          ]
        ),
    );
  }
}