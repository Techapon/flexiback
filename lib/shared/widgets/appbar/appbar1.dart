import 'package:flexiback/config/theme/colors/app_color.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class Appbar1 extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String? pathImag;
  final IconData? icon;
  final Function? action;
  const Appbar1({
    super.key,
    required this.title,
    this.pathImag,
    this.icon,
    this.action
  });

  @override
  Size get preferredSize => Size.fromHeight(35.7+24);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      // backgroundColor: AppColor.grey1,
      elevation: 0,
      scrolledUnderElevation: 10.0, 
      shadowColor: AppColor.black1.withOpacity(0.2),
      surfaceTintColor: Colors.transparent,
      
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Text(
                title.toUpperCase(),
                style: GoogleFonts.paytoneOne(
                  fontSize: 26,
                  wordSpacing: 4,
                  foreground: Paint()..shader = LinearGradient(
                    colors:AppColor.mainGradientColrs
                  ).createShader(Rect.fromLTWH(0, 0, 100, 70))
                ),
              ),

              if (pathImag != null)
                Positioned(
                  right: -47.5,
                  child: Image.asset(
                    pathImag ?? "",
                    height: 37.5,
                  ),
                )
            ],
          ),

          if (icon != null)
            GestureDetector(
              onTap: () {
                if (action != null) action!(); 
              },
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 0),
                child: Icon(
                    icon,
                    size: 24,
                    color: AppColor.main2,
                ),
              ),
            )

        ],
      ),
    );
  }
}