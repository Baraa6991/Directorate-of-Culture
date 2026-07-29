import 'package:directorateofculture/Constant/color_manager.dart';
import 'package:directorateofculture/presentation/util/custom_container.dart';
import 'package:directorateofculture/presentation/util/custom_elevatedButton.dart';
import 'package:directorateofculture/presentation/util/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'archive_event_model.dart';
import 'archive_status_badge.dart';

/// Reservation card for the "الفعاليات" (Events) tab of ArchiveScreen.
class ArchiveEventCard extends StatelessWidget {
  final ArchiveEventModel event;
  final VoidCallback? onAction;

  const ArchiveEventCard({super.key, required this.event, this.onAction});

  String get _statusLabel {
    switch (event.status) {
      case ArchiveReservationStatus.confirmedPaid:
        return 'مؤكد وتم الدفع';
      case ArchiveReservationStatus.underReview:
        return 'قيد المراجعة';
      case ArchiveReservationStatus.rejected:
        return 'تم رفض التسجيل';
      case ArchiveReservationStatus.awaitingPayment:
        return 'بانتظار الدفع';
      case ArchiveReservationStatus.completed:
        return 'مكتمل';
    }
  }

  bool get _hasImage =>
      event.imageAsset != null && event.imageAsset!.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    final rejected = event.status == ArchiveReservationStatus.rejected;

    return CustomContainer(
      width: double.infinity,
      color: ColorManager.titleWhite,
      radius: 18,
      paddingAll: 14,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_hasImage)
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(14.r),
                  child: Image.asset(
                    event.imageAsset!,
                    height: 140.h,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 10.h,
                  right: 10.w,
                  child: _CategoryPill(label: event.categoryBadge),
                ),
              ],
            )
          else
            Row(
              children: [
                Icon(
                  Icons.cancel,
                  color: ColorManager.rejectedRed,
                  size: 20.sp,
                ),
                SizedBox(width: 8.w),
                CustomText(
                  event.categoryBadge,
                  color: ColorManager.gray,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ],
            ),
          SizedBox(height: 12.h),
          CustomText(
            event.title,
            color: ColorManager.black,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          if (event.description != null) ...[
            SizedBox(height: 6.h),
            CustomText(
              event.description!,
              color: ColorManager.gray,
              fontSize: 12,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
          if (event.date != null && event.date!.isNotEmpty ||
              event.time != null) ...[
            SizedBox(height: 10.h),
            Row(
              children: [
                if (event.time != null) ...[
                  Icon(
                    Icons.access_time,
                    size: 14.sp,
                    color: ColorManager.gray,
                  ),
                  SizedBox(width: 4.w),
                  Flexible(
                    child: CustomText(
                      event.time!,
                      color: ColorManager.gray,
                      fontSize: 12,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                  SizedBox(width: 14.w),
                ],
                if (event.date != null && event.date!.isNotEmpty) ...[
                  Icon(
                    Icons.calendar_today,
                    size: 13.sp,
                    color: ColorManager.gray,
                  ),
                  SizedBox(width: 4.w),
                  Flexible(
                    child: CustomText(
                      event.date!,
                      color: ColorManager.gray,
                      fontSize: 12,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                ],
              ],
            ),
          ],
          if (event.reservationCode != null || event.location != null) ...[
            SizedBox(height: 6.h),
            Row(
              children: [
                if (event.reservationCode != null) ...[
                  Icon(
                    Icons.confirmation_number_outlined,
                    size: 14.sp,
                    color: ColorManager.gray,
                  ),
                  SizedBox(width: 4.w),
                  Flexible(
                    child: CustomText(
                      event.reservationCode!,
                      color: ColorManager.gray,
                      fontSize: 12,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                  SizedBox(width: 14.w),
                ],
                if (event.location != null) ...[
                  Icon(
                    Icons.location_on_outlined,
                    size: 14.sp,
                    color: ColorManager.gray,
                  ),
                  SizedBox(width: 4.w),
                  Expanded(
                    child: CustomText(
                      event.location!,
                      color: ColorManager.gray,
                      fontSize: 12,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ],
            ),
          ],
          SizedBox(height: 14.h),
          if (rejected) ...[
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(12.r),
              decoration: BoxDecoration(
                color: ColorManager.rejectedRed.withOpacity(0.08),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    _statusLabel,
                    color: ColorManager.rejectedRed,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                  if (event.rejectionReason != null) ...[
                    SizedBox(height: 4.h),
                    CustomText(
                      'السبب: ${event.rejectionReason!}',
                      color: ColorManager.rejectedRed,
                      fontSize: 12,
                    ),
                  ],
                ],
              ),
            ),
            SizedBox(height: 10.h),
            SizedBox(
              width: double.infinity,
              child: CustomElevatedButton(
                onPressed: onAction,
                backgroundColor: ColorManager.lightBackground,
                foregroundColor: ColorManager.black,
                radius: 20,
                paddingVertical: 12,
                child: CustomText(
                  event.actionLabel,
                  color: ColorManager.black,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ] else
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: CustomElevatedButton(
                    onPressed: onAction,
                    backgroundColor:
                        event.status == ArchiveReservationStatus.confirmedPaid
                        ? ColorManager.deepGreen
                        : ColorManager.titleWhite,
                    foregroundColor:
                        event.status == ArchiveReservationStatus.confirmedPaid
                        ? ColorManager.titleWhite
                        : ColorManager.deepGreen,
                    borderColor:
                        event.status == ArchiveReservationStatus.confirmedPaid
                        ? null
                        : ColorManager.deepGreen,
                    radius: 20,
                    paddingHorizontal: 16,
                    paddingVertical: 10,
                    child: CustomText(
                      event.actionLabel,
                      color:
                          event.status == ArchiveReservationStatus.confirmedPaid
                          ? ColorManager.titleWhite
                          : ColorManager.deepGreen,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                ),
                SizedBox(width: 8.w),
                Flexible(
                  child: ArchiveStatusBadge(
                    status: event.status,
                    label: _statusLabel,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

class _CategoryPill extends StatelessWidget {
  final String label;

  const _CategoryPill({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: ColorManager.titleWhite.withOpacity(0.9),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: CustomText(
        label,
        color: ColorManager.darkForestGreen,
        fontSize: 11,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
