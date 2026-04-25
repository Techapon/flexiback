import 'package:flutter/material.dart';

import '../../../../config/theme/colors/app_color.dart';

class GradientButton extends StatelessWidget {
  final Function onTap;
  final Widget child;
  final bool? disable;
  const GradientButton({
    super.key,
    required this.onTap,
    required this.child,
    this.disable
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: (disable != null && disable!) 
        ? null
        : LinearGradient(
          colors:AppColor.mainGradientColrs
        )
        ,
        color: (disable != null && disable!) ? AppColor.grey2 : null,
        borderRadius: BorderRadius.circular(18),
      ),
      child: FilledButton(
        style: FilledButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 16),
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