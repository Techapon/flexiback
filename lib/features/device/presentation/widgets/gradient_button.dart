import 'package:flutter/material.dart';

import '../../../../config/theme/colors/app_color.dart';

class GradientButton extends StatelessWidget {
  final Function onTap;
  final Widget child;
  final bool disable;
  final bool useMaxWidth;
  const GradientButton({
    super.key,
    required this.onTap,
    required this.child,
    this.disable = false,

    this.useMaxWidth = true
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: useMaxWidth ? double.infinity : null,
      decoration: BoxDecoration(
        gradient: disable
        ? null
        : LinearGradient(
          colors:AppColor.mainGradientColrs
        )
        ,
        color: disable ? AppColor.grey2 : null,
        borderRadius: BorderRadius.circular(18),
      ),
      child: FilledButton(
        style: FilledButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 16,horizontal: 16),
          backgroundColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
        onPressed: () {
          onTap();
        },
        child: child
      ),
    );
  }
}