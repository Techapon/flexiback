import 'package:flexiback/config/theme/colors/app_color.dart';
import 'package:flexiback/features/profile/domain/entities/therapist_entity.dart';
import 'package:flexiback/features/relation/domain/entities/relation_entity.dart';
import 'package:flexiback/features/relation/domain/entities/message_entity.dart';
import 'package:flexiback/features/relation/domain/enums/message_enums.dart';
import 'package:flexiback/features/relation/presentation/controller/relation_provider.dart';
import 'package:flexiback/features/relation/presentation/widgets/text_box_sender.dart';
import 'package:flexiback/features/relation/presentation/widgets/text_box_talker.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';

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
  bool _isSending = false;

  late RelationProvider _relationProvider;

  // Scroll
  late ScrollController _scrollController;

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,  
      );
    }
  }


  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
      if (mounted) {
        _relationProvider = context.read<RelationProvider>();
      }
    });
  }



  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    
    if (_scrollController.hasClients) {
      _scrollToBottom();
    }
  }

  @override
  void dispose() {
    _relationProvider.clearChat();
    contextC.dispose();
    _scrollController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    final relationProvider = context.watch<RelationProvider>(); 

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
                      child: StreamBuilder(
                        stream: relationProvider.chatStream, 
                        builder: (context, snapshot) {

                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Center(
                              child: Container(
                                height: MediaQuery.of(context).size.height * 0.75,
                                child: Center(
                                  child: CircularProgressIndicator()
                                ),
                              ),
                            );
                          }

                          if (snapshot.hasError) {
                            return Center(
                              child: Container(
                                height: MediaQuery.of(context).size.height * 0.75,
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    spacing: 4,
                                    children: [
                                      Icon(
                                        LucideIcons.triangleAlert,
                                        color: AppColor.error,
                                        size: 50,
                                      ),
                                      Text(
                                        "${relationProvider.error}",
                                        style: TextStyle(
                                          color: AppColor.black1,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }

                          if (!snapshot.hasData) {
                            return Center(
                              child: Container(
                                height: MediaQuery.of(context).size.height * 0.75,
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    spacing: 4,
                                    children: [
                                      Icon(
                                        LucideIcons.triangleAlert,
                                        color: AppColor.error,
                                        size: 50,
                                      ),
                                      Text(
                                        "Some thing went wrong, \n Please try again.",
                                        style: TextStyle(
                                          color: AppColor.black1,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }

                          final chatList = snapshot.data!;

                          if (chatList.length == 0) {
                            return Center(
                              child: Container(
                                height: MediaQuery.of(context).size.height * 0.75,
                                child: Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    spacing: 8,
                                    children: [
                                      Icon(
                                        LucideIcons.send,
                                        color: AppColor.grey3,
                                        size: 24,
                                      ),
                                      Text(
                                        "Send your fisrt message!",
                                        style: TextStyle(
                                          color: AppColor.grey3,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold
                                        )
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }

                          return ListView.builder(
                            controller: _scrollController,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: chatList.length,
                            itemBuilder: (context, index) {
                              final message = chatList[index];

                              final bool isBeforeMessageMine = index == 0 
                                ? false
                                : chatList[index -1].isMine!;
                              
                              if (message.isMine!) {
                                return Padding(
                                  padding: EdgeInsets.only(top: isBeforeMessageMine ? 2 : 8),
                                  child: TextBoxSender(text: message.content),
                                );
                              } else {
                                return Padding(
                                  padding: EdgeInsets.only(top: !isBeforeMessageMine ? 2 : 8),
                                  child: TextBoxTalker(text: message.content)
                                );
                              }
                            }, 
                          );
                        }
                      )
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
                                if (contextC.text.trim().isEmpty) return;
                                
                                setState(() {
                                  _isSending = true;
                                });
                                
                                final message = MessageEntity(
                                  recipient: widget.freinds.userProfile!.id,
                                  type: MessageType.message,
                                  content: contextC.text.trim(),
                                  send_at: DateTime.now(),
                                );
                                
                                await _relationProvider.sendMessage(message);
                                contextC.clear();
                                
                                setState(() {
                                  _isSending = false;
                                });
                              }, 
                              icon: _isSending
                                ? SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(AppColor.base1),
                                    ),
                                  )
                                : Icon(
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