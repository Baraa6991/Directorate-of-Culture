import 'package:directorateofculture/Constant/color_manager.dart';
import 'package:directorateofculture/presentation/pages/Home/model/activity_model.dart';
import 'package:directorateofculture/presentation/util/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class PastEventsCart extends StatelessWidget {
  final ActivityModel activity;

  const PastEventsCart({super.key, required this.activity});

  String get _formattedDate {
    if (activity.startTime == null) return '';
    return DateFormat('MMM d, yyyy • HH:mm').format(activity.startTime!);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: ColorManager.titleWhite,
        borderRadius: BorderRadius.circular(18.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(14.r),
            child: (activity.image != null && activity.image!.isNotEmpty)
                ? Image.network(
                    activity.image!,
                    height: 90.h,
                    width: 90.w,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 90.h,
                        width: 90.w,
                        color: ColorManager.lightBackground,
                        child: Icon(
                          Icons.image_outlined,
                          color: ColorManager.gray,
                        ),
                      );
                    },
                  )
                : Container(
                    height: 90.h,
                    width: 90.w,
                    color: ColorManager.lightBackground,
                    child: Icon(
                      Icons.image_outlined,
                      color: ColorManager.gray,
                    ),
                  ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ====================== العنوان ======================
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: CustomText(
                        activity.title,
                        color: ColorManager.black,
                        fontSize: 15.sp,
                        fontWeight: FontWeight.bold,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Icon(
                      Icons.favorite_border,
                      size: 20.sp,
                      color: ColorManager.black,
                    ),
                  ],
                ),
                SizedBox(height: 4.h),
                // ====================== الوصف ======================
                CustomText(
                  activity.description,
                  color: ColorManager.black,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 8.h),

                // ====================== التقييم (معلّق مؤقتاً) ======================
                // Row(
                //   children: [
                //     Icon(Icons.star, size: 14.sp, color: Colors.orange),
                //     SizedBox(width: 4.w),
                //     CustomText(
                //       '4.7',
                //       color: ColorManager.black,
                //       fontSize: 12.sp,
                //     ),
                //   ],
                // ),
                // SizedBox(height: 4.h),

                // ====================== التاريخ ======================
                if (_formattedDate.isNotEmpty)
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: 13.sp,
                        color: ColorManager.black,
                      ),
                      SizedBox(width: 4.w),
                      CustomText(
                        _formattedDate,
                        color: ColorManager.black,
                        fontSize: 12.sp,
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}