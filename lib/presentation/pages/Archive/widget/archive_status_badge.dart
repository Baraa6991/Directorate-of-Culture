import 'package:directorateofculture/Constant/color_manager.dart';
import 'package:directorateofculture/presentation/util/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'archive_event_model.dart';

/// Small color-coded status pill shown on both event and center reservation
/// cards (see ArchiveEventCard / ArchiveCenterCard). Not general-purpose
/// enough to promote to presentation/util — the color mapping is specific
/// to [ArchiveReservationStatus].
class ArchiveStatusBadge extends StatelessWidget {
  final ArchiveReservationStatus status;
  final String label;

  const ArchiveStatusBadge({
    super.key,
    required this.status,
    required this.label,
  });

  Color get _color {
    switch (status) {
      case ArchiveReservationStatus.confirmedPaid:
        return ColorManager.accentGreen;
      case ArchiveReservationStatus.underReview:
        return ColorManager.liveBadge;
      case ArchiveReservationStatus.rejected:
        return ColorManager.rejectedRed;
      case ArchiveReservationStatus.awaitingPayment:
        return ColorManager.awaitingBlue;
      case ArchiveReservationStatus.completed:
        return ColorManager.gray;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _color;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.circle, size: 7.sp, color: color),
          SizedBox(width: 6.w),
          Flexible(
            child: CustomText(
              label,
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.w600,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }
}
