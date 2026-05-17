import 'package:flexiback/config/theme/colors/app_color.dart';
import 'package:flexiback/core/enums/role.dart';
import 'package:flexiback/features/profile/domain/entities/general_entity.dart';
import 'package:flexiback/features/profile/domain/entities/profile_entity.dart';
import 'package:flexiback/features/profile/domain/entities/therapist_entity.dart';
import 'package:flexiback/features/relation/presentation/widgets/profile_view/general_profile_view.dart';
import 'package:flexiback/features/relation/presentation/widgets/profile_view/therapist_profile_view.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';

import '../../../../shared/widgets/status/loading/loading_status.dart';
import '../../../trend/presentation/controller/trend_provider.dart';
import '../../../trend/presentation/pages/graph_trend.dart';

class PersonalProfileDialog extends StatelessWidget {
  final Role userRole;
  final ProfileEntity relationUserProfile;
  const PersonalProfileDialog({
    super.key, 
    required this.userRole,
    required this.relationUserProfile
  });

  @override
  Widget build(BuildContext context) {
    final trendProvider = context.watch<TrendProvider>();


    if (trendProvider.deviceUsageCalendar == null) {
      return Dialog(
        backgroundColor: AppColor.base1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24)
        ),
        child: IntrinsicHeight(child: Padding(
          padding: EdgeInsets.symmetric(vertical: 32),
          child: LoadingStatus(text: "Loading '${relationUserProfile.fullname == "Not yet named" ? relationUserProfile.email : relationUserProfile.fullname}' data",),
        )),
      );
    }

    // print(trendProvider.deviceUsageCalendar.toString());

    return Dialog(
      backgroundColor:  Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24)
      ),
      child: IntrinsicWidth(
        child: Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: Colors.transparent,
            border: BoxBorder.all(color: AppColor.grey2,width: 3),
            borderRadius: BorderRadius.circular(24)
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              FilledButton(
                style: FilledButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  minimumSize: Size.zero,
                  backgroundColor: AppColor.base1,
                  foregroundColor: AppColor.grey3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(21),
                      bottom: relationUserProfile is GeneralEntity ?  Radius.zero : Radius.circular(21),
                    ),
                  ),
                ),
                onPressed: () {
                  if (relationUserProfile is TherapistEntity) {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => TherapistProfileView(therapistProfile: relationUserProfile as TherapistEntity,)));
                  } else if (relationUserProfile is GeneralEntity) {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => GeneralProfileView(generalProfile: relationUserProfile as GeneralEntity,)));
                  }
                }, 
                child: Padding(
                  padding: EdgeInsets.only(left: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    spacing: 8,
                    children: [
                      Icon(
                        LucideIcons.user,
                        size: 28,
                        color: AppColor.grey4,
                      ),
                      Text(
                        "Profile",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColor.grey4
                        ),
                      ),
                    ],
                  ),
                )
              ),
              if (relationUserProfile is GeneralEntity)
                FilledButton(
                  style: FilledButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    minimumSize: Size.zero,
                    backgroundColor: AppColor.base1,
                    foregroundColor: AppColor.grey3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: relationUserProfile is GeneralEntity ? Radius.zero : Radius.circular(21),
                        bottom: Radius.circular(21),
                      ),
                    ),
                  ),
                  onPressed: () {
                    trendProvider.getFullDataUsage(relationUserProfile.id, trendProvider.deviceUsageCalendar!.last);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => GraphTrend(
                          userId: relationUserProfile.id,
                          lastedtDay: trendProvider.deviceUsageCalendar!.last,
                          fromCalendar: false,
                          isFromTherapistView: userRole == Role.General,
                          userFromTherapist: relationUserProfile,
                        )
                      )
                    );
                  }, 
                  child: Padding(
                      padding: EdgeInsets.only(left: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        spacing: 8,
                        children: [
                          Icon(
                            LucideIcons.chartColumnIncreasing,
                            size: 28,
                            color: AppColor.grey4,
                          ),
                          Text(
                            "Therapy Progress",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColor.grey4
                            ),
                          ),
                        ],
                      ),
                  )
                )
            ],
          ),
        ),
      ),
    );
  }
}