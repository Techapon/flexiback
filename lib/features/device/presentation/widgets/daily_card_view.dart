import 'package:flexiback/config/theme/colors/app_color.dart';
import 'package:flexiback/features/device/domain/entities/daily_progress_entity.dart';
import 'package:flexiback/shared/widgets/dialog/image_showcase/image_showcase.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';


class DailyCardView extends StatefulWidget {
  final DailyProgressEntity  item;
  final Function? onTapBin;
  const DailyCardView({
    super.key,
    required this.item,
    this.onTapBin
  });

  @override
  State<DailyCardView> createState() => _DailyCardViewState();
}

class _DailyCardViewState extends State<DailyCardView> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 24,vertical: 30),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 550
        ),
        child: SingleChildScrollView(
          child: Stack(
            children: [
          
              // main content
              Container(
                padding: EdgeInsets.only(
                  left: 24,
                  right: 24,
                  top: 24,
                  bottom: 16
                ),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColor.base2,
                  border: Border.all(
                    color: AppColor.grey2,
                    width: 2
                  ),
                  borderRadius: BorderRadius.circular(18)
                ),
                child: Column(
                  spacing: 16,
                  mainAxisSize: MainAxisSize.min,
                  children: [
              
                    // Image
                    GestureDetector(
                      onTap: () {
                        if (widget.item.img == null) return;
              
                        ImageShowcase(context,  NetworkImage("${widget.item.img}"));
                      },
                      child: Container(
                        height: 280,
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                          color: AppColor.grey1,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppColor.grey2,
                            width: 2
                          )
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8) ,
                          child: Image.network(
                            "${widget.item.img}",
                            fit: BoxFit.fitHeight,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: AppColor.grey2,
                                child: Icon(
                                  Icons.broken_image,
                                  color: AppColor.grey3,
                                ),
                              );
                            },
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Center(
                                child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes != null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                      : null,
                                  strokeWidth: 2,
                                  color: AppColor.base1,
                                ),
                              );
                            },
                          ),
                        )
                      ),
                    ),
              
                    Column(
                      spacing: 8,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "${widget.item.formattedDate ?? 'date not found'}",
                          style: TextStyle(
                            color: AppColor.grey3,
                            fontWeight: FontWeight.bold,
                            fontSize: 16
                          ),
                        ),
                        Divider(color: AppColor.grey2,),
              
                        Text(
                          "Staight Score : ${widget.item.straightScore ?? 'null'}",
                          style: TextStyle(
                            color: AppColor.black1,
                            fontSize: 16,
                            fontWeight: FontWeight.bold
                          ),
                        ),
              
                        Text(
                          "Note",
                          style: TextStyle(
                            color: AppColor.black1,
                            fontSize: 16,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                        
                        Container(
                          height: 120,
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColor.base1,
                            border: Border.all(
                              color: AppColor.grey2,
                              width: 1.5
                            ),
                            borderRadius: BorderRadius.circular(8)
                          ),
                          child: SingleChildScrollView(
                            physics: BouncingScrollPhysics(),
                            child: Text(
                              "${widget.item.getNote ?? '. . .'}",
                              style: TextStyle(
                                color: widget.item.getNote != null ? AppColor.black1 : AppColor.grey3,
                                fontSize: 16,
                                fontWeight: FontWeight.bold
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
        
                    Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton.filled(
                              style: IconButton.styleFrom(
                                padding: EdgeInsets.all(8),
                                foregroundColor: AppColor.red1,
                                backgroundColor: AppColor.grey2,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              onPressed: () {
                                if (widget.onTapBin != null) widget.onTapBin!();
                              },
                              icon: Icon(
                                LucideIcons.trash2Weight400,
                                color: AppColor.base1,
                              )
                            ),
                          ],
                        )
                  ],
                )
              ),
          
              Positioned(
                right: 0,
                child: IconButton(
                  style: IconButton.styleFrom(
                    foregroundColor: AppColor.grey3
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    LucideIcons.x500,
                    color: AppColor.grey3,
                    size: 22,
                  )
                ),
              )
          
            ],
          ),
        ),
      ),
    );
  }
}