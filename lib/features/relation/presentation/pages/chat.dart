import 'dart:math' as math;

import 'package:flexiback/config/theme/colors/app_color.dart';
import 'package:flexiback/core/enums/role.dart';
import 'package:flexiback/core/mappers/get_role.dart';
import 'package:flexiback/features/profile/presentation/controller/profile_provider.dart';
import 'package:flexiback/features/relation/domain/entities/relation_reqeuest_entity.dart';
import 'package:flexiback/features/relation/domain/enums/relation_enums.dart';
import 'package:flexiback/features/relation/presentation/controller/relation_provider.dart';
import 'package:flexiback/shared/widgets/appbar/appbar1.dart';
import 'package:flexiback/shared/widgets/dialog/comfirm/dialog_comfirm.dart';
import 'package:flexiback/shared/widgets/dialog/error/dialog_error.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  bool searching = false;
  
  final TextEditingController searchC = TextEditingController();

  Role? userRole;

  String? sendingUsersId;

  @override
  void initState() {
    super.initState();

    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   final profileProvider = context.read<ProfileProvider>();
      
    //   if (profileProvider.profile != null) {
    //     userRole = profileProvider.role;
    //   } else {
    //     profileProvider.getProfile().then((_) {
    //       if (profileProvider.profile != null) {
    //         userRole = profileProvider.role;
    //         setState(() {});
    //       }
    //     });
    //   }
    // });
  }

  @override
  Widget build(BuildContext context) {
    final relationProvider = context.watch<RelationProvider>();
    final profileProvider = context.watch<ProfileProvider>();

    if (!profileProvider.isLoading && profileProvider.profile != null) {
      userRole = profileProvider.role;
    }

    return Scaffold(
      appBar: Appbar1(
        title: "message"
      ),
      backgroundColor: AppColor.base3,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16
          ),
          child: Column(
            spacing: 16,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () async {
                  if (profileProvider.isLoading || userRole == null) return;
                  relationProvider.searchUsers(getOppositeRole(userRole!.entity),);
                  relationProvider.getRequests();
                  setState(() {
                    searching = true;
                  });
                },
                child: Row(
                  spacing: 8,
                  children: [

                    if (searching)
                      Container(
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: AppColor.black1.withOpacity(0.05),
                              spreadRadius: 2,
                              blurRadius: 8,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: IconButton(
                          padding: EdgeInsets.all(16),
                          style: IconButton.styleFrom(
                            backgroundColor: AppColor.base1,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14)
                            ),
                          ),
                          icon: Icon(
                            LucideIcons.chevronLeft,
                            color: AppColor.black1,
                            size: 26,
                          ),
                          onPressed: () {
                            setState(() {
                              searching = false;
                              searchC.clear();
                            });
                          },
                        ),
                      ),

                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColor.base1,
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: AppColor.black1.withOpacity(0.05),
                              spreadRadius: 2,
                              blurRadius: 8,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          spacing: 16,
                          children: [
                      
                            if (!searching)
                              Icon(
                                LucideIcons.search300,
                                color: AppColor.grey3,
                                size: 26,
                              ),
                            
                            Expanded(
                              child: TextFormField(
                                controller: searchC,
                                enabled: searching,
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  isDense: true,
                                  contentPadding: EdgeInsets.zero,
                                  hintText: "Search your ${
                                    profileProvider.isLoading || userRole == null
                                    ? '...' 
                                    : getOppositeRole(userRole!.entity) == Role.General ? 'Therapist' : 'Patient'
                                  }",
                                  hintStyle: TextStyle(
                                    fontSize: 18,
                                    color: AppColor.grey3,
                                    fontWeight: FontWeight.w500
                                  ),
                                ),
                                onChanged: (value) {
                                  setState(() {});
                                },
                                style: TextStyle(
                                  fontSize: 18,
                                  color: AppColor.black1,
                                  fontWeight: FontWeight.w500
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              if (searching)
                Builder(builder: (context) {
                  final filteredList = !relationProvider.isLoading && relationProvider.searchUsersList != null
                    ? relationProvider.searchUsersList!.where((user) => 
                        searchC.text.isEmpty || 
                        user.email.toLowerCase().contains(searchC.text.toLowerCase())
                      ).toList()
                    : null;
                  
                  return Expanded(
                    child: ListView.separated(
                      itemCount: !relationProvider.isLoading ? filteredList?.length ?? 0 : 20,
                      separatorBuilder: (context, index) => SizedBox(height: 8,),
                      itemBuilder: (context,index) {
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
                                      
                                      image: !relationProvider.isLoading && filteredList != null
                                      ? (filteredList[index].img != null)
                                        ? DecorationImage(
                                          image: NetworkImage(
                                            filteredList[index].img!),
                                            fit: BoxFit.cover
                                        )
                                        : null
                                      : null
                                    ),
                                    child: !relationProvider.isLoading && filteredList != null
                                    ? (filteredList[index].img == null)
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
                                    if (!relationProvider.isLoading && filteredList != null) ...[
                                      Text(
                                        filteredList[index].fullname,
                                        style: TextStyle(
                                          color: AppColor.black1,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold
                                        ),
                                      ),
                                      Text(
                                        filteredList[index].email,
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

                            if (!relationProvider.isLoading && filteredList != null)
                              () {
                                final userId = filteredList[index].id;
                                final Relation relation = relationProvider.getRelation(userId);

                                return IconButton(
                                  style: IconButton.styleFrom(
                                    foregroundColor: AppColor.grey4
                                  ),
                                  onPressed: () async {
                                    switch (relation) {
                                      case (Relation.none) :
                                        if (relationProvider.isRequesting || relationProvider.isLoading) return;
                                        sendingUsersId = userId;

                                        await relationProvider.sendRelationRequest(
                                          userId,
                                          userRole!
                                        );

                                        if (relationProvider.error != null) {
                                          showErrorDialog(context: context, message: relationProvider.error!);
                                        }
                                        sendingUsersId = null;
                                        relationProvider.searchUsers(getOppositeRole(userRole!.entity),);
                                        relationProvider.getRequests();
                                        break;

                                      case (Relation.request) :
                                        final RelationReqeuestEntity request = relationProvider.requestList!
                                          .singleWhere(
                                            (item) => item.recipientId == userId
                                          );
                                        
                                        showComfirmDialog(
                                          context: context,
                                          title: "Delete request",
                                          message: "Are you sure to cancel your request",
                                          comfirm: "Yes, Cancel it",
                                          cancel: "No, Keep it",
                                          onConfirm: () async {
                                            await relationProvider.deleteRequest(request.id).then((_) {
                                                relationProvider.searchUsers(getOppositeRole(userRole!.entity),);
                                                relationProvider.getRequests();
                                              }
                                            );
                                          }
                                        );

                                        break;
                                    }
                                  },
                                  icon: relationProvider.isRequesting && sendingUsersId == userId
                                    ? SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: AppColor.black1,
                                        ),
                                      )
                                    : Row(
                                      spacing: 4,
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        
                                        
                                        Icon(
                                          switch (relation) {
                                            Relation.none => LucideIcons.plus,
                                            Relation.request => LucideIcons.send,
                                          },
                                          color: AppColor.black1,
                                          size: 20,
                                        ),


                                        Text(
                                          switch (relation) {
                                            Relation.none => '',
                                            Relation.request => "Requested",
                                          },
                                          style: TextStyle(
                                            color: AppColor.black1,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold
                                          ),
                                        )
                                      ],
                                    )
                                );
                              }()

                          ],
                        ),
                      );
                    }
                  )
                );
              }),

              if (!searching)
                Expanded(
                  child: Stack(
                    alignment: AlignmentGeometry.topLeft,
                    children: [
                  
                      Padding(
                        padding: EdgeInsets.only(left: 4),
                        child: Transform.rotate(
                          angle: -15  * (math.pi / 180),
                          child: Image.asset(
                            "assets/emoji/fox.png",
                            height: 40,
                            width: 40,
                          ),
                        ),
                      ),
                  
                      Container(
                        margin: EdgeInsets.only(top: 20),
                        padding: EdgeInsets.all(24),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: AppColor.base1,
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(50)
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColor.black1.withOpacity(0.05),
                              spreadRadius: 2,
                              blurRadius: 8,
                              offset: Offset(0, 0),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            
                          ],
                        ),
                      )
                    ],
                  ),
                ),


            ],
          ),
        )
      ),
    );
  }
}