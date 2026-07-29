import 'package:directorateofculture/Constant/color_manager.dart';
import 'package:directorateofculture/presentation/util/custom_container.dart';
import 'package:directorateofculture/presentation/util/custom_elevatedButton.dart';
import 'package:directorateofculture/presentation/util/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'archive_center_model.dart';
import 'archive_event_model.dart' show ArchiveReservationStatus;
import 'archive_status_badge.dart';

/// Reservation card for the "المراكز الثقافية" (Cultural Centers) tab of
/// ArchiveScreen.
class ArchiveCenterCard extends StatelessWidget {
  final ArchiveCenterModel center;
  final VoidCallback? onAction;
  final VoidCallback? onShare;

  const ArchiveCenterCard({
    super.key,
    required this.center,
    this.onAction,
    this.onShare,
  });

  String get _statusLabel {
    switch (center.status) {
      case ArchiveReservationStatus.confirmedPaid:
        return 'تم التأكيد';
      case ArchiveReservationStatus.underReview:
        return 'قيد المراجعة';
      case ArchiveReservationStatus.rejected:
        return 'تم الرفض';
      case ArchiveReservationStatus.awaitingPayment:
        return 'بانتظار الدفع';
      case ArchiveReservationStatus.completed:
        return 'مكتمل';
    }
  }

  bool get _isFilledAction =>
      center.status == ArchiveReservationStatus.awaitingPayment ||
      center.status == ArchiveReservationStatus.confirmedPaid;

  bool get _isDisabledAction =>
      center.status == ArchiveReservationStatus.rejected;

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      width: double.infinity,
      color: ColorManager.titleWhite,
      radius: 18,
      paddingAll: 14,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            center.reservationCode,
            color: ColorManager.gray,
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
          SizedBox(height: 6.h),
          CustomText(
            center.title,
            color: ColorManager.black,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          SizedBox(height: 6.h),
          Row(
            children: [
              Icon(Icons.calendar_today, size: 13.sp, color: ColorManager.gray),
              SizedBox(width: 4.w),
              Flexible(
                child: CustomText(
                  center.date,
                  color: ColorManager.gray,
                  fontSize: 12,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          ArchiveStatusBadge(status: center.status, label: _statusLabel),
          if (center.status == ArchiveReservationStatus.rejected &&
              center.rejectionReason != null) ...[
            SizedBox(height: 10.h),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(12.r),
              decoration: BoxDecoration(
                color: ColorManager.rejectedRed.withOpacity(0.08),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: CustomText(
                center.rejectionReason!,
                color: ColorManager.rejectedRed,
                fontSize: 12,
              ),
            ),
          ],
          if (center.actionLabel.isNotEmpty) ...[
            SizedBox(height: 12.h),
            Row(
              children: [
                if (center.showShareIcon) ...[
                  InkWell(
                    onTap: onShare,
                    borderRadius: BorderRadius.circular(20.r),
                    child: Container(
                      padding: EdgeInsets.all(10.r),
                      decoration: BoxDecoration(
                        border: Border.all(color: ColorManager.lightGray),
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Icon(
                        Icons.share_outlined,
                        size: 16.sp,
                        color: ColorManager.darkForestGreen,
                      ),
                    ),
                  ),
                  SizedBox(width: 10.w),
                ],
                Expanded(
                  child: CustomElevatedButton(
                    onPressed: _isDisabledAction ? null : onAction,
                    backgroundColor: _isDisabledAction
                        ? ColorManager.lightBackground
                        : (_isFilledAction
                              ? ColorManager.deepGreen
                              : ColorManager.titleWhite),
                    foregroundColor: _isDisabledAction
                        ? ColorManager.gray
                        : (_isFilledAction
                              ? ColorManager.titleWhite
                              : ColorManager.deepGreen),
                    borderColor: _isFilledAction || _isDisabledAction
                        ? null
                        : ColorManager.deepGreen,
                    radius: 20,
                    paddingVertical: 12,
                    child: CustomText(
                      center.actionLabel,
                      color: _isDisabledAction
                          ? ColorManager.gray
                          : (_isFilledAction
                                ? ColorManager.titleWhite
                                : ColorManager.deepGreen),
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
