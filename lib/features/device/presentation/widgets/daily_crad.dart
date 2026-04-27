import 'package:flexiback/config/theme/colors/app_color.dart';
import 'package:flexiback/features/device/domain/entities/daily_progress_entity.dart';
import 'package:flutter/material.dart';

class DailyCard extends StatelessWidget {
  final DailyProgressEntity  item;
  final Function? ontap;
  const DailyCard({
    super.key,
    required this.item,
    this.ontap
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (ontap != null) ontap!();
      },
      child: Container(
        padding: EdgeInsets.all(16),
        width: 240,
        decoration: BoxDecoration(
          color: AppColor.base2,
          border: Border.all(
            color: AppColor.grey2,
            width: 2
          ),
          borderRadius: BorderRadius.circular(14)
        ),
        child: Column(
          spacing: 16,
          children: [
      
            // Image
            Container(
              height: 160,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: AppColor.grey1,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: AppColor.grey2,
                  width: 2
                )
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8) ,
                child: Image.network(
                  "${item.img}",
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
      
            Column(
              spacing: 8,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "${item.formattedDate ?? 'date not found'}",
                  style: TextStyle(
                    color: AppColor.grey3,
                    fontWeight: FontWeight.bold,
                    fontSize: 14
                  ),
                ),
                Divider(color: AppColor.grey2,),
      
                Text(
                  "Staight Score : ${item.straightScore ?? 'null'}",
                  style: TextStyle(
                    color: AppColor.black1,
                    fontSize: 14,
                    fontWeight: FontWeight.bold
                  ),
                ),
      
                Text(
                  "Note",
                  style: TextStyle(
                    color: AppColor.black1,
                    fontSize: 14,
                    fontWeight: FontWeight.bold
                  ),
                ),
                
                Container(
                  height: 84,
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColor.base1,
                    border: Border.all(
                      color: AppColor.grey2,
                      width: 1.5
                    ),
                    borderRadius: BorderRadius.circular(8)
                  ),
                  child: Text(
                    "${item.getNote ?? '. . .'}",
                    style: TextStyle(
                      color: item.getNote != null ? AppColor.black1 : AppColor.grey3,
                      fontSize: 14,
                      fontWeight: FontWeight.bold
                    ),
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            )
      
          ],
        )
      ),
    );
  }
}