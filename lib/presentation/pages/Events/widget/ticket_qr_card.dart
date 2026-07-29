import 'package:directorateofculture/Constant/color_manager.dart';
import 'package:directorateofculture/presentation/util/custom_container.dart';
import 'package:directorateofculture/presentation/util/custom_text.dart';
import 'package:flutter/material.dart';

/// Booking-confirmation ticket card.
///
/// The QR block is a static icon, not a real generated QR code.
class TicketQrCard extends StatelessWidget {
  final String activityName;
  final String tierLabel;
  final String date;
  final String time;
  final String bookingId;
  final String seat;
  final String scanCaption;

  const TicketQrCard({
    super.key,
    required this.activityName,
    required this.date,
    required this.time,
    required this.bookingId,
    required this.seat,
    this.tierLabel = 'مميز',
    this.scanCaption =
        'امسح هذا الرمز عند مدخل القاعة الرئيسية للمركز الثقافي.',
  });

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      width: double.infinity,
      color: ColorManager.titleWhite,
      radius: 20,
      paddingAll: 18,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                'النشاط',
                color: ColorManager.gray,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: ColorManager.premiumBadge,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: CustomText(
                  tierLabel,
                  color: ColorManager.darkForestGreen,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          CustomText(
            activityName,
            color: ColorManager.deepGreen,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _TicketField(label: 'التاريخ', value: date),
              ),
              Expanded(
                child: _TicketField(label: 'الوقت', value: time),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _TicketField(
                  label: 'رقم الحجز',
                  value: bookingId,
                  valueColor: ColorManager.accentGreen,
                ),
              ),
              Expanded(
                child: _TicketField(label: 'المقعد', value: seat),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Center(
            child: Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                color: ColorManager.darkForestGreen,
                borderRadius: BorderRadius.circular(14),
              ),
              alignment: Alignment.center,
              child: Icon(
                Icons.qr_code_2,
                size: 110,
                color: ColorManager.titleWhite,
              ),
            ),
          ),
          const SizedBox(height: 12),
          CustomText(
            scanCaption,
            color: ColorManager.gray,
            fontSize: 12,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _TicketField extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _TicketField({
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(label, color: ColorManager.gray, fontSize: 11),
        const SizedBox(height: 4),
        CustomText(
          value,
          color: valueColor ?? ColorManager.black,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ],
    );
  }
}
