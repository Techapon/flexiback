import 'package:flexiback/config/theme/colors/app_color.dart';
import 'package:flexiback/core/utils/text_uppercase.dart';
import 'package:flexiback/features/relation/presentation/controller/relation_provider.dart';
import 'package:flexiback/features/relation/presentation/pages/message.dart';
import 'package:flexiback/features/relation/presentation/widgets/personal_profile_dialog.dart' show PersonalProfileDialog;
import 'package:flexiback/shared/widgets/general/gradient_button.dart';
import 'package:flexiback/features/profile/domain/entities/general_entity.dart';
import 'package:flexiback/features/profile/domain/entities/therapist_entity.dart';
import 'package:flexiback/features/relation/domain/entities/relation_entity.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';

import '../../../../../core/enums/role.dart';
import '../../../../trend/presentation/controller/trend_provider.dart';

class GeneralChatCard extends StatefulWidget {
  final RelationEntity freinds;
  const GeneralChatCard({
    super.key,
    required this.freinds
  });

  @override
  State<GeneralChatCard> createState() => _GeneralChatCardState();
}

class _GeneralChatCardState extends State<GeneralChatCard> {

  @override
  Widget build(BuildContext context) {
    final relationProvider = context.watch<RelationProvider>(); 
    final profile = widget.freinds.userProfile! as GeneralEntity;
    
    return Column(
      spacing: 16,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          spacing: 16,
          children: [
            GestureDetector(
              onTap: () {
                final trendProvider = context.read<TrendProvider>();
                trendProvider.disposeProvi();
                trendProvider.getOverviewData(profile.id);

                showDialog(
                  context: context,
                  builder: (context) => PersonalProfileDialog(userRole: Role.General,relationUserProfile: profile,)
                );
              },
              child: Container(
                height: 65,
                width: 65,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColor.base1,
                    width: 3
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColor.black1.withOpacity(0.1),
                      blurRadius: 15,
                      spreadRadius: 2,
                      offset: Offset(0, 5),
                    ),
                  ],
              
                  image: (profile.img != null)
                      ? DecorationImage(
                          image: NetworkImage("${profile.img}"),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: (profile.img == null)
                    ? Icon(
                        LucideIcons.user300,
                        color: AppColor.grey3,
                        size: 40,
                      )
                    : null,
              ),
            ),
  
            Flexible(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    profile.fullname,
                    style: TextStyle(
                      color: AppColor.black1,
                      fontSize: 22,
                      fontWeight: FontWeight.bold
                    ),
                  ),
              
                  Text(
                    "Tel : ${profile.getNumber}",
                    style: TextStyle(
                      color: AppColor.grey3,
                      fontSize: 14,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),

                  Text(
                    "Email : ${toFirstLetterUpper(profile.email)}",
                    style: TextStyle(
                      color: AppColor.grey3,
                      fontSize: 14,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            )
          ],
        ),

        // Column(
        //   spacing: 0,
        //   crossAxisAlignment: CrossAxisAlignment.start,
        //   children: [
        //     Text(
        //       "Tel : ${profile.getNumber}",
        //       style: TextStyle(
        //         color: AppColor.grey3,
        //         fontSize: 14
        //       ),
        //     ),

        //     Text(
        //       "Email : ${toFirstLetterUpper(profile.email)}",
        //       style: TextStyle(
        //         color: AppColor.grey3,
        //         fontSize: 14
        //       ),
        //     )
        //   ],
        // ),

        SizedBox(height: 2,),
        
        Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 8
          ),
          child: GradientButton(
            onTap: () {
              relationProvider.getChat(profile.id);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Message(freinds: widget.freinds,))
              );
            },
            borderRadius: 28,
            paddingV: 14,
            isFilter: true,
            child: Text(
              "Open Chat!",
              style: TextStyle(
                color: AppColor.base1,
                fontSize: 16,
                fontWeight: FontWeight.bold
              ),
            )
          ),
        ),

        Divider(color: AppColor.base3,thickness: 3,radius: BorderRadius.circular(20),)


      ]
    );
  }
}