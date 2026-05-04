import 'package:flexiback/config/theme/colors/app_color.dart';
import 'package:flexiback/features/profile/domain/entities/therapist_entity.dart';
import 'package:flexiback/features/relation/domain/entities/relation_entity.dart';
import 'package:flexiback/features/relation/presentation/widgets/text_box_sender.dart';
import 'package:flexiback/features/relation/presentation/widgets/text_box_talker.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class Message extends StatefulWidget {
  final RelationEntity freinds;
  const Message({
    super.key,
    required this.freinds
  });

  @override
  State<Message> createState() => _MessageState();
}

class _MessageState extends State<Message> {

  final TextEditingController contextC = TextEditingController();

  @override
  void dispose() {
    contextC.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    final profile = widget.freinds.userProfile!;
    
    return Scaffold(
      backgroundColor: AppColor.base1,
      body: SafeArea(
        child: Column(
          children: [
            
            // Head Part
            Container(
              padding: EdgeInsets.symmetric(
                vertical: 7,
                horizontal: 16
              ),
              child: Row(
                spacing: 8,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(
                    style: IconButton.styleFrom(
                      backgroundColor: AppColor.base1,
                      elevation: 2,
                      shadowColor: AppColor.black1.withOpacity(.2),
                      
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.arrow_back_rounded,
                      color: AppColor.black1,
                      size: 36,
                    )
                  ),

                  Row(
                    spacing: 8,
                    children: [
                      Container(
                        height: 55,
                        width: 55,
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

                      Text(
                        "${profile.fullname}",
                        style: TextStyle(
                          color: AppColor.black1,
                          fontSize: 20,
                          fontWeight: FontWeight.bold
                        ),
                      )
                    ],
                  ),
                  
                ],
              ),
            ),

            // Content
            Expanded(
              child: Stack(
                children: [
              
                  SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.only(top: 32),
                      child: Column(
                        spacing: 8,
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                      
                          TextBoxSender(
                            text: "and often fell pain when I sit and work for long periods of time.",
                          ),

                          TextBoxTalker(
                            text: "Hello Fifa!! I have some questions about my diagnosis that might be helpful to you.",
                          )
                          
                        ],
                      ),
                    ),
                  ),
              
                  Positioned(
                    bottom: 16,
                    left: 0,
                    right: 0,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColor.grey0,
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Row(
                          spacing: 8,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                          
                            if (contextC.text == '')
                              FilledButton(
                                style: FilledButton.styleFrom(
                                  backgroundColor: AppColor.base1,
                                  shape: CircleBorder(),
                                  padding: EdgeInsets.all(11),
                                  minimumSize: Size.zero,
                                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                ),
                                onPressed: () {}, 
                                child: ShaderMask(
                                  blendMode: BlendMode.srcIn,
                                  shaderCallback: (Rect bounds) {
                                    return LinearGradient(colors: AppColor.mainGradientColrs,).createShader(bounds);
                                  },
                                  child: Icon(
                                    LucideIcons.plus500,
                                    color: AppColor.base1,
                                    size: 24,
                                  ),
                                )
                              ),

                            Flexible(
                              child: Padding(
                                padding: EdgeInsets.only(left: contextC.text == '' ? 0 :16),
                                child: TextFormField(
                                  controller: contextC,
                                  keyboardType: TextInputType.text,
                                  maxLines: 1,
                                  maxLength: 200,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    isDense: true,
                                    contentPadding: EdgeInsets.zero,
                                    counterText: "",
                                    hintText: "",
                                    hintStyle: TextStyle(
                                      color: AppColor.grey3,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  onChanged: (value) {
                                    setState(() {});
                                  },
                                  style: TextStyle(
                                    color: AppColor.black1,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  )
                                  
                                ),
                              ),
                            ),
                                  
                            IconButton(
                              style: IconButton.styleFrom(
                                backgroundColor: AppColor.main2,
                                foregroundColor: AppColor.base1,
                                shape: CircleBorder(),
                                padding: EdgeInsets.all(11),
                                minimumSize: Size.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              onPressed: () async {
                                  
                              }, 
                              icon: Icon(
                                LucideIcons.send300,
                                color: AppColor.base1,
                                size: 24,
                              )
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        )
      )
    );
  }
}