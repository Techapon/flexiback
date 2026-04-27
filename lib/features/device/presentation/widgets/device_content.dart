import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../config/theme/colors/app_color.dart';

class DeviceContent extends StatelessWidget {
  final String title;
  final String imagPath;
  final String btnText;
  final VoidCallback onTap;
  const DeviceContent({
    super.key,
    required this.title,
    required this.imagPath,
    required this.btnText,
    required this.onTap
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16,horizontal: 8),
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColor.base1,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          width: 1.5,
          color: AppColor.grey2
        )
      ),
    
      child: Column(
        spacing: 8,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            style: GoogleFonts.paytoneOne(
              color: AppColor.black1,
              fontSize: 26
            ),
          ),
    
          Image.asset(
            imagPath,
            height: 65,
          ),
    
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.base1, 
              foregroundColor:AppColor.grey1,
              elevation: 4,                 
              shadowColor: AppColor.base3.withOpacity(0.5),

              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              padding: EdgeInsets.symmetric(vertical: 0,horizontal: 14),
    
              side: BorderSide(
                color: AppColor.grey1, 
                width: .75,        
              ), 
            ),
            onPressed: onTap,
            child: ShaderMask(
              blendMode: BlendMode.srcIn, 
              shaderCallback: (Rect bounds) {
                return LinearGradient(
                  colors: AppColor.mainGradientColrs,
                ).createShader(bounds); 
              },
              child: Text(
                btnText,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            )
          )
        ],
      ),
    );
  }
}