import 'package:directorateofculture/Constant/color_manager.dart';
import 'package:directorateofculture/presentation/pages/Events/Page/event_details_screen.dart';
import 'package:directorateofculture/presentation/pages/Home/model/activity_model.dart';
import 'package:directorateofculture/presentation/util/custom_elevatedButton.dart';
import 'package:directorateofculture/presentation/util/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class FeaturedEventsCart extends StatelessWidget {
  final ActivityModel activity;

  const FeaturedEventsCart({super.key, required this.activity});

  String get _formattedDate {
    if (activity.startTime == null) return '';
    return DateFormat('MMM d • HH:mm').format(activity.startTime!);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280.w,
      margin: EdgeInsets.only(right: 30.w),
      decoration: BoxDecoration(
        border: Border.all(color: ColorManager.gray, width: 1.5.w),
        color: ColorManager.titleWhite,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                child: (activity.image != null && activity.image!.isNotEmpty)
                    ? Image.network(
                        activity.image!,
                        height: 150.h,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            height: 150.h,
                            color: ColorManager.lightBackground,
                            child: Icon(
                              Icons.image_outlined,
                              color: ColorManager.gray,
                            ),
                          );
                        },
                      )
                    : Container(
                        height: 150.h,
                        width: double.infinity,
                        color: ColorManager.lightBackground,
                        child: Icon(
                          Icons.image_outlined,
                          color: ColorManager.gray,
                        ),
                      ),
              ),
              // ====================== النوع فوق الصورة ======================
              if (activity.type.isNotEmpty)
                Positioned(
                  top: 12.h,
                  left: 12.w,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 5.h),
                    decoration: BoxDecoration(
                      color: ColorManager.accentGreen,
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: CustomText(
                      activity.type.toUpperCase(),
                      color: ColorManager.titleWhite,
                      fontSize: 11.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
          Padding(
            padding: EdgeInsets.all(14.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  activity.title,
                  color: ColorManager.black,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 10.h),
                if (_formattedDate.isNotEmpty)
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: 14.sp,
                        color: ColorManager.black,
                      ),
                      SizedBox(width: 6.w),
                      CustomText(
                        _formattedDate,
                        color: ColorManager.black,
                        fontSize: 13.sp,
                      ),
                    ],
                  ),
                SizedBox(height: 6.h),
                // ====================== المركز التابع له ======================
                Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      size: 14.sp,
                      color: ColorManager.black,
                    ),
                    SizedBox(width: 6.w),
                    Expanded(
                      child: CustomText(
                        activity.centerName ??
                            'مركز رقم ${activity.culturalCenterId ?? "-"}',
                        color: ColorManager.black,
                        fontSize: 13.sp,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 17.h),
                CustomElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            EventDetailsScreen(activityId: activity.id),
                      ),
                    );
                  },
                  backgroundColor: ColorManager.deepGreen,
                  foregroundColor: ColorManager.titleWhite,
                  radius: 24.r,
                  fixedSize: const Size(double.infinity, 46),
                  child: CustomText(
                    'احجز الآن',
                    color: ColorManager.titleWhite,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}