import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../config/theme/colors/app_color.dart';

void showComfirmDialog({
  required BuildContext context,
  required String title,
  required String message,

  String? comfirm,
  String? cancel,

  required Function onConfirm,
  Function? onCancel,

  Color? color,
  IconData? icon,
}) {
  showDialog(
    context: context,
    builder: (context) {
      return ComfirmDialog(
        title: title,
        message: message,
        comfirm: comfirm,
        cancel: cancel,
        onConfirm: onConfirm,
        onCancel: onCancel,
        color: color,
        icon: icon,
      );
    },
  );
}

class ComfirmDialog extends StatefulWidget {
  final String title;
  final String message;

  final String? comfirm;
  final String? cancel;

  final Function onConfirm;
  final Function? onCancel;

  final  Color? color;
  final IconData? icon;
  
  const ComfirmDialog({
    super.key,
    required this.title,
    required this. message,

    this.comfirm,
    this.cancel,

    required this.onConfirm,
    this.onCancel,

    this.color,
    this.icon
  });

  @override
  State<ComfirmDialog> createState() => _ComfirmDialogState();
}

class _ComfirmDialogState extends State<ComfirmDialog> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !isLoading,
      child: Dialog(
        insetPadding: EdgeInsets.all(0),
          backgroundColor:  AppColor.base1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24)
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: 250
            ),
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Column(
                spacing: 12,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 4),
                    child: Icon(
                      widget.icon ?? LucideIcons.triangleAlert,
                      size: 55,
                      color: widget.color ??  AppColor.error,
                    ),
                  ),
                  
                  
                  Column(
                    spacing: 2,
                    children: [
                      Text(
                        widget.title,
                        style: TextStyle(
                          color: AppColor.black1,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        widget.message,
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 12,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  
                  SizedBox(height: 4,),
                  
                  Container(
                    child: Row(
                      spacing: 8,
                      children: [
                        Expanded(
                          child: FilledButton(
                            style: FilledButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 12),
                              backgroundColor: AppColor.grey2,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: () {
                              if (isLoading) return;
                              if (widget.onCancel != null) {
                                setState(() {
                                  isLoading = true;
                                });

                                widget.onCancel!();
                              }

                              Navigator.pop(context);
                            },
                            child: Text("${widget.cancel ?? "Cancel"}", style: TextStyle(fontWeight: FontWeight.bold,color: AppColor.black1),),
                          ),
                        ),
                    
                        Expanded(
                          child: FilledButton(
                            style: FilledButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 12),
                              backgroundColor: widget.color ?? AppColor.error,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: () async {
                              if (isLoading) return;
                  
                              
                              setState(() {
                                isLoading = true;
                              });
                  
                              await widget.onConfirm();
                              Navigator.pop(context);
                            },
                            child: !isLoading 
                              ? Text("${widget.comfirm ?? "Yes"}", style: TextStyle(fontWeight: FontWeight.bold),)
                              : SizedBox(
                                height: 16,
                                width: 16,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2.5,
                                ),
                              ),
                          ),
                        ),
                      ],
                    ),
                  ),
            
                ],
              ),
            ),
          ),
        ),
    );
  }
}