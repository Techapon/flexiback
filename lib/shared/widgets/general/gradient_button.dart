import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../config/theme/colors/app_color.dart';

class GradientButton extends StatelessWidget {
  final Function onTap;
  final Widget child;
  final bool disable;
  final bool useMaxWidth;


  final double borderRadius;
  final double  paddingV;
  final double  paddingH;

  final bool isFilter;

  const GradientButton({
    super.key,
    required this.onTap,
    required this.child,
    this.disable = false,

    this.useMaxWidth = true,
    this.borderRadius = 18,
    this.paddingV = 16,
    this.paddingH = 16,

    this.isFilter = false
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
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter:  ImageFilter.blur(
            sigmaX: isFilter ? 35 : 0,
            sigmaY: isFilter ? 20 : 0
          ),
          child: FilledButton(
            style: FilledButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: paddingV, horizontal: paddingH),
              backgroundColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(borderRadius),
              ),
            ),
            onPressed: () {
              onTap();
            },
            child: child
          ),
        ),
      ),
    );
  }
}