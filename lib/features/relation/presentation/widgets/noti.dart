import 'package:flexiback/config/theme/colors/app_color.dart';
import 'package:flexiback/core/enums/role.dart';
import 'package:flexiback/core/mappers/get_role.dart';
import 'package:flexiback/shared/widgets/general/gradient_button.dart';
import 'package:flexiback/features/relation/presentation/controller/relation_provider.dart';
import 'package:flexiback/shared/widgets/dialog/comfirm/dialog_comfirm.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';

import '../../../profile/domain/entities/profile_entity.dart';

class Noti extends StatefulWidget {
  final Role userRole;
  const Noti({
    super.key,
    required this.userRole
  });

  @override
  State<Noti> createState() => _NotiState();
}

class _NotiState extends State<Noti> {
  late final RelationProvider _relationProvider;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _relationProvider = context.read<RelationProvider>();
      _relationProvider.clearRequest();

      await _relationProvider.searchUsers(getOppositeRole(widget.userRole!.entity),);
      await _relationProvider.getRequests();
      await _relationProvider.getIncomeRequests();
    });
  }

  @override
  Widget build(BuildContext context) {
    final relationProvider = context.watch<RelationProvider>();

    return Scaffold(
      backgroundColor: AppColor.base1,
      body: SafeArea(
        child: Column(
          spacing: 16,
          children: [
            Container(
              padding: EdgeInsets.symmetric(
                vertical: 7,
                horizontal: 4
              ),
              decoration: BoxDecoration(
                color: AppColor.base1,
                border: Border(
                  bottom: BorderSide(
                    color: AppColor.grey1,
                    width: 1
                  )
                )
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    }, 
                    icon: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: AppColor.black1,
                      size: 20,
                    )
                  ),
                  Text(
                    "Notification",
                    style: TextStyle(
                      color: AppColor.black1,
                      fontSize: 20,
                      fontWeight: FontWeight.bold
                    ),
                  )
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: 16
                ),
              child: Column(
                spacing: 8,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [

                  Text(
                    "Your Request",
                    style: TextStyle(
                      color: AppColor.black1,
                      fontSize: 16,
                      fontWeight: FontWeight.bold
                    ),
                  ),
              
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      if (relationProvider.requestList?.length == 0)
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: Row(
                            spacing: 4,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                LucideIcons.mailSearch,
                                color: AppColor.grey2,
                                size: 24,
                              ),
                          
                              Text(
                                "No request sent",
                                style: TextStyle(
                                  color: AppColor.grey2,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold
                                ),
                              )
                            ],
                          ),
                        ),

                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: 
                          relationProvider.searchUsersList == null 
                          || relationProvider.requestList == null 
                            ? 3 
                            : relationProvider.requestList?.length ?? 3,
                        itemBuilder: (context, index) {
                          final request = relationProvider.requestList != null ? relationProvider.requestList![index] : null;
                          
                          final ProfileEntity? requestUsreProfile = 
                          relationProvider.searchUsersList != null 
                          && 
                          relationProvider.requestList != null
                          ? relationProvider.searchUsersList!
                          .where(
                            (user) => request?.recipientId == user.id
                          ).firstOrNull 
                          : null;
                          
                          return Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: !relationProvider.isLoading ? AppColor.base1 : Colors.transparent,
                              borderRadius: BorderRadius.circular(14)
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                      
                                Row(
                                  spacing: 8,
                                  children: [
                                    Container(
                                      clipBehavior: Clip.antiAlias,
                                      width: 50,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        color: !relationProvider.isLoading ? AppColor.base1 : AppColor.grey1,
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: AppColor.grey1,
                                          width: 1.5
                                        ),
                                        
                                        image: !relationProvider.isLoading && requestUsreProfile != null
                                        ? (requestUsreProfile.img != null)
                                          ? DecorationImage(
                                            image: NetworkImage(
                                              requestUsreProfile.img!),
                                              fit: BoxFit.cover
                                          )
                                          : null
                                        : null
                                      ),
                                      child: !relationProvider.isLoading && requestUsreProfile != null
                                      ? (requestUsreProfile.img == null)
                                        ? Icon(
                                          LucideIcons.image300,
                                          color: AppColor.grey3,
                                          size: 20,
                                        )
                                        : SizedBox.shrink()
                                      : Icon(
                                          LucideIcons.user300,
                                          color: AppColor.grey3,
                                          size: 20,
                                        ),
                                    ),
                      
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      if (!relationProvider.isLoading && requestUsreProfile != null) ...[
                                        Text(
                                          requestUsreProfile.fullname,
                                          style: TextStyle(
                                            color: AppColor.black1,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold
                                          ),
                                        ),
                                        Text(
                                          requestUsreProfile.email,
                                          style: TextStyle(
                                            color: AppColor.grey3,
                                            fontSize: 12,
                                          ),
                                        )
                                      ],
                      
                                      if (relationProvider.isLoading) ...[
                                        Container(
                                          height: 15,
                                          width: 80,
                                          decoration: BoxDecoration(
                                            color: AppColor.grey2,
                                            borderRadius: BorderRadius.circular(4)
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        Container(
                                          height: 10,
                                          width: 150,
                                          decoration: BoxDecoration(
                                            color: AppColor.grey1,
                                            borderRadius: BorderRadius.circular(4)
                                          ),
                                        )
                                      ]
                                    ],
                                  )
                                ],
                              ),
                      
                              if (requestUsreProfile != null)
                                FilledButton(
                                  style: FilledButton.styleFrom(
                                    foregroundColor: AppColor.base1,
                                    backgroundColor: AppColor.grey2,
                                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                    minimumSize: Size.zero,
                                    padding: EdgeInsets.symmetric(
                                      vertical: 9.5,
                                      horizontal: 20
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  onPressed: () async {
                                    if (relationProvider.isLoading || relationProvider.searchUsersList == null) return;
                                    showComfirmDialog(
                                      context: context,
                                      title: "Delete request",
                                      message: "Are you sure to cancel your request",
                                      comfirm: "Yes, Cancel it",
                                      cancel: "No, Keep it",
                                      onConfirm: () async {
                                        await relationProvider.deleteRequest(request!.id).then((_) {
                                            relationProvider.searchUsers(getOppositeRole(widget.userRole!.entity),);
                                            relationProvider.getRequests();
                                          }
                                        );
                                      }
                                    );
                                  },
                                  child:Text(
                                    "Cancel",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                ),
                            ],
                          ),
                        );
                        }
                      ),
                    ],
                  ),

                  // Receive request
                  Text(
                    "Request received",
                    style: TextStyle(
                      color: AppColor.black1,
                      fontSize: 16,
                      fontWeight: FontWeight.bold
                    ),
                  ),
              
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      if (relationProvider.incomeList?.length == 0)
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: Row(
                            spacing: 4,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.people_alt_outlined,
                                color: AppColor.grey2,
                                size: 24,
                              ),
                          
                              Text(
                                "No request yet",
                                style: TextStyle(
                                  color: AppColor.grey2,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold
                                ),
                              )
                            ],
                          ),
                        ),

                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: relationProvider.searchUsersList == null 
                          || relationProvider.incomeList == null 
                            ? 3 
                            : relationProvider.incomeList?.length ?? 3,
                        itemBuilder: (context, index) {
                          final receiveRequest = relationProvider.incomeList != null ? relationProvider.incomeList![index] : null;
                          
                          final ProfileEntity? receiveRequestUserProfile = 
                          relationProvider.searchUsersList != null 
                          && 
                          relationProvider.incomeList != null
                          ? relationProvider.searchUsersList!
                          .where(
                            (user) => receiveRequest?.requesterId == user.id
                          ).firstOrNull 
                          : null;

                          return Container(
                            padding: EdgeInsets.all(8),
                           child: Column(
                              // crossAxisAlignment: ,
                              spacing: 10,
                              children: [

                                // content
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                                      
                                    Row(
                                      spacing: 8,
                                      children: [
                                        Container(
                                          clipBehavior: Clip.antiAlias,
                                          width: 50,
                                          height: 50,
                                          decoration: BoxDecoration(
                                            color: !relationProvider.isLoading ? AppColor.base1 : AppColor.grey1,
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: AppColor.grey1,
                                              width: 1.5
                                            ),
                                            
                                            image: !relationProvider.isLoading && receiveRequestUserProfile != null
                                            ? (receiveRequestUserProfile.img != null)
                                              ? DecorationImage(
                                                image: NetworkImage(
                                                  receiveRequestUserProfile.img!),
                                                  fit: BoxFit.cover
                                              )
                                              : null
                                            : null
                                          ),
                                          child: !relationProvider.isLoading && receiveRequestUserProfile != null
                                          ? (receiveRequestUserProfile.img == null)
                                            ? Icon(
                                              LucideIcons.image300,
                                              color: AppColor.grey3,
                                              size: 20,
                                            )
                                            : SizedBox.shrink()
                                          : Icon(
                                              LucideIcons.user300,
                                              color: AppColor.grey3,
                                              size: 20,
                                            ),
                                        ),
                                                      
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          if (!relationProvider.isLoading && receiveRequestUserProfile != null) ...[
                                            Text(
                                              receiveRequestUserProfile.fullname,
                                              style: TextStyle(
                                                color: AppColor.black1,
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold
                                              ),
                                            ),
                                            Text(
                                              receiveRequestUserProfile.email,
                                              style: TextStyle(
                                                color: AppColor.grey3,
                                                fontSize: 12,
                                              ),
                                            )
                                          ],
                                                      
                                          if (relationProvider.isLoading) ...[
                                            Container(
                                              height: 15,
                                              width: 80,
                                              decoration: BoxDecoration(
                                                color: AppColor.grey2,
                                                borderRadius: BorderRadius.circular(4)
                                              ),
                                            ),
                                            SizedBox(height: 4),
                                            Container(
                                              height: 10,
                                              width: 150,
                                              decoration: BoxDecoration(
                                                color: AppColor.grey1,
                                                borderRadius: BorderRadius.circular(4)
                                              ),
                                            )
                                          ]
                                        ],
                                      )
                                    ],
                                  ),
                                  ],
                                ),

                                // action
                                if (receiveRequestUserProfile != null)
                                    Row(
                                      spacing: 8,
                                      children: [
                                    
                                        Expanded(
                                          child: FilledButton(
                                            style: FilledButton.styleFrom(
                                              foregroundColor: AppColor.base1,
                                              backgroundColor: AppColor.grey2,
                                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                              minimumSize: Size.zero,
                                              padding: EdgeInsets.symmetric(
                                                vertical: 9.5,
                                                horizontal: 20
                                              ),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                            ),
                                            onPressed: () async {
                                              if (relationProvider.isLoading || relationProvider.searchUsersList == null) return;
                                              showComfirmDialog(
                                                context: context,
                                                title: "Decline request",
                                                message: "Are you sure to decline this request",
                                                comfirm: "Yes",
                                                cancel: "No",
                                                onConfirm: () async {
                                                  await relationProvider.deleteRequest(receiveRequest!.id).then((_) {
                                                      relationProvider.searchUsers(getOppositeRole(widget.userRole!.entity),);
                                                      relationProvider.getIncomeRequests();
                                                    }
                                                  );
                                                },
                                              );
                                            },
                                            child:Text(
                                              "Decline",
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            )
                                          ),
                                        ),
                                    
                                        Expanded(
                                          child: Container(
                                            decoration: BoxDecoration(
                                              gradient:  LinearGradient(
                                                colors:AppColor.mainGradientColrs
                                              ),
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                            child: FilledButton(
                                              style: FilledButton.styleFrom(
                                                foregroundColor: AppColor.base1,
                                                backgroundColor: Colors.transparent,
                                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                                minimumSize: Size.zero,
                                                padding: EdgeInsets.symmetric(
                                                  vertical: 9.5,
                                                  horizontal: 20
                                                ),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(10),
                                                ),
                                              ),
                                              onPressed: () async {
                                                if (relationProvider.isLoading || relationProvider.searchUsersList == null) return;
                                                showComfirmDialog(
                                                  context: context,
                                                  title: "Appect request",
                                                  message: "Are you sure to appect this request",
                                                  comfirm: "Yes",
                                                  cancel: "No",
                                                  onConfirm: () async {
                                                    await relationProvider.acceptRequest(receiveRequest!).then((_) {
                                                        relationProvider.searchUsers(getOppositeRole(widget.userRole!.entity),);
                                                        relationProvider.getIncomeRequests();
                                                      }
                                                    );
                                                  },
                                            
                                                  color: AppColor.success,
                                                  icon: LucideIcons.messageCircleCheck300
                                                );
                                              },
                                              child:Text(
                                                "Accept",
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              )
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                              ],
                            ),
                        );
                        }
                      ),
                    ],
                  ),
                ],
              ),
              ),
            )
          ],
        )
      ),
    );
  }
}