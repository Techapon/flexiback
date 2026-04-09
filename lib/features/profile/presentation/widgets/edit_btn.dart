import 'package:flutter/material.dart';

import '../../../../shared/theme/colors/app_color.dart';

class EditBtn extends StatefulWidget {
  final VoidCallback onTap;

  const EditBtn({
    super.key,
    required this.onTap
  });

  @override
  State<EditBtn> createState() => _EditBtnState();
}

class _EditBtnState extends State<EditBtn> {
  @override
  Widget build(BuildContext context) {
    return FilledButton(
      style: FilledButton.styleFrom(
        backgroundColor: AppColor.main2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        padding: EdgeInsets.symmetric(vertical: 12,horizontal: 24),
      ),
      onPressed: widget.onTap,
      child: Row(
        spacing: 4,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.edit_outlined,
            size: 24,
            color: AppColor.base1,
          ),
          Text(
            'Edit Profile',
            style: TextStyle(
              fontSize: 16,
              color: AppColor.base1,
              fontWeight: FontWeight.bold
            ),
          ),
        ],
      )
    );
  }
}