import 'package:directorateofculture/Constant/color_manager.dart';
import 'package:directorateofculture/presentation/pages/Center%20Details/page/hall_booking_data_screen.dart';
import 'package:directorateofculture/presentation/pages/Home/model/venue_model.dart';
import 'package:directorateofculture/presentation/util/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class ReservationOptionCart extends StatelessWidget {
  final VenueModel venue;
  final String centerId;

  const ReservationOptionCart({
    super.key,
    required this.venue,
    required this.centerId,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.r),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // venue image
          if (venue.imageUrl.isNotEmpty)
            ClipRRect(
              borderRadius: BorderRadius.circular(12.r),
              child: Image.network(
                venue.imageUrl,
                height: 120.h,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const SizedBox.shrink(),
              ),
            ),
          if (venue.imageUrl.isNotEmpty) SizedBox(height: 12.h),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: CustomText(
                  venue.name,
                  color: ColorManager.darkForestGreen,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                padding:
                    EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: ColorManager.lightGreen.withOpacity(0.35),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: CustomText(
                  venue.type,
                  color: ColorManager.darkForestGreen,
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          // capacity
          Row(
            children: [
              Icon(Icons.people_outline,
                  size: 16.sp, color: ColorManager.gray),
              SizedBox(width: 6.w),
              CustomText(
                'سعة ${venue.capacity} شخص',
                color: ColorManager.gray,
                fontSize: 13.sp,
              ),
            ],
          ),
          // features
          if (venue.features.isNotEmpty) ...[
            SizedBox(height: 6.h),
            Row(
              children: [
                Icon(Icons.star_outline,
                    size: 16.sp, color: ColorManager.gray),
                SizedBox(width: 6.w),
                Expanded(
                  child: CustomText(
                    venue.features.join(' • '),
                    color: ColorManager.gray,
                    fontSize: 13.sp,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
          SizedBox(height: 16.h),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => HallBookingDataScreen(
                      centerId: centerId,
                      venueId: venue.id,
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorManager.darkForestGreen,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.r)),
                padding: EdgeInsets.symmetric(vertical: 14.h),
              ),
              child: CustomText(
                'احجز الآن',
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
                color: ColorManager.titleWhite,
              ),
            ),
          ),
        ],
      ),
    );
  }
}