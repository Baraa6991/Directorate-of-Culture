import 'package:directorateofculture/Constant/color_manager.dart';
import 'package:directorateofculture/presentation/pages/Events/Model/event_model.dart';
import 'package:directorateofculture/presentation/util/custom_container.dart';
import 'package:directorateofculture/presentation/util/custom_elevatedButton.dart';
import 'package:directorateofculture/presentation/util/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class ActivityCard extends StatelessWidget {
  final ActivityCardModel activity;
  final VoidCallback? onBook;
  final VoidCallback? onFavoriteToggle;

  const ActivityCard({
    super.key,
    required this.activity,
    this.onBook,
    this.onFavoriteToggle,
  });

  // ─── ألوان الشارة حسب نوع النشاط ───
  Color get _badgeColor {
    switch (activity.type) {
      case 'lecture':
      case 'exhibition':
        return ColorManager.lightGreen;
      default: // show, festival ...
        return ColorManager.deepGreen;
    }
  }

  Color get _badgeTextColor {
    switch (activity.type) {
      case 'lecture':
      case 'exhibition':
        return ColorManager.deepGreen;
      default:
        return ColorManager.titleWhite;
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      color: ColorManager.titleWhite,
      radius: 20.r,
      shadowColor: ColorManager.black.withOpacity(0.08),
      shadowBlurRadius: 10,
      shadowOffset: const Offset(0, 4),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // ─── صورة النشاط + زر المفضلة ───
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.r),
                  topRight: Radius.circular(20.r),
                ),
                child: Image.network(
                  activity.imageUrl,
                  height: 110.h,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 110.h,
                    color: ColorManager.lightGray.withOpacity(0.3),
                    alignment: Alignment.center,
                    child: Icon(Icons.image_not_supported,
                        color: ColorManager.gray),
                  ),
                  loadingBuilder: (context, child, progress) {
                    if (progress == null) return child;
                    return Container(
                      height: 110.h,
                      color: ColorManager.lightGray.withOpacity(0.2),
                      alignment: Alignment.center,
                      child: const CircularProgressIndicator(strokeWidth: 2),
                    );
                  },
                ),
              ),
              Positioned(
                top: 8.h,
                right: 8.w,
                child: GestureDetector(
                  onTap: onFavoriteToggle,
                  child: CustomContainer(
                    width: 30.w,
                    height: 30.h,
                    color: ColorManager.black.withOpacity(0.35),
                    shape: BoxShape.circle,
                    alignment: Alignment.center,
                    child: Icon(
                      activity.isFavorite
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: ColorManager.titleWhite,
                      size: 16.sp,
                    ),
                  ),
                ),
              ),
            ],
          ),

          // ─── محتوى الكارد ───
          CustomContainer(
            paddingAll: 12,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // شارة النوع
                CustomContainer(
                  color: _badgeColor,
                  radius: 20.r,
                  paddingHorizontal: 10,
                  paddingVertical: 4,
                  child: CustomText(
                    activity.typeLabel,
                    color: _badgeTextColor,
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 8.h),

                // العنوان
                CustomText(
                  activity.title,
                  fontSize: 15.sp,
                  fontWeight: FontWeight.bold,
                  color: ColorManager.black,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 6.h),

                // التاريخ والوقت
                Row(
                  children: [
                    Icon(Icons.calendar_today_outlined,
                        size: 13.sp, color: ColorManager.gray),
                    SizedBox(width: 4.w),
                    Expanded(
                      child: CustomText(
                        '${activity.dateLabel} • ${activity.timeLabel}',
                        fontSize: 12.sp,
                        color: ColorManager.gray,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4.h),

                // الموقع
                Row(
                  children: [
                    Icon(Icons.location_on_outlined,
                        size: 13.sp, color: ColorManager.gray),
                    SizedBox(width: 4.w),
                    Expanded(
                      child: CustomText(
                        activity.locationLabel,
                        fontSize: 12.sp,
                        color: ColorManager.gray,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 6.h),

                // المقاعد المتاحة
                CustomText(
                  activity.seatsLabel,
                  fontSize: 12.5.sp,
                  fontWeight: FontWeight.w600,
                  color: ColorManager.mediumGreen,
                ),
                SizedBox(height: 10.h),

                // زر الحجز
                SizedBox(
                  width: double.infinity,
                  child: CustomElevatedButton(
                    onPressed: onBook,
                    backgroundColor: ColorManager.deepGreen,
                    radius: 12.r,
                    paddingVertical: 12,
                    child: CustomText(
                      'احجز',
                      color: ColorManager.titleWhite,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
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