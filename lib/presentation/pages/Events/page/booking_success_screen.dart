import 'package:directorateofculture/Constant/color_manager.dart';
import 'package:directorateofculture/presentation/pages/Events/widget/event_model.dart';
import 'package:directorateofculture/presentation/pages/Events/widget/saved_ticket_dialog.dart';
import 'package:directorateofculture/presentation/pages/Events/widget/ticket_qr_card.dart';
import 'package:directorateofculture/presentation/util/custom_elevatedButton.dart';
import 'package:directorateofculture/presentation/util/custom_text.dart';
import 'package:flutter/material.dart';

class BookingSuccessScreen extends StatelessWidget {
  final EventModel event;
  final int attendeeCount;

  const BookingSuccessScreen({
    super.key,
    required this.event,
    required this.attendeeCount,
  });

  String get _bookingId => '#GCC-${event.id.hashCode.abs() % 100000}';
  String get _seat => 'الصف أ، ${attendeeCount.toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: ColorManager.titleWhite,
        // Close icon used as the leading action instead of a back arrow,
        // since this screen ends the booking flow.
        appBar: AppBar(
          backgroundColor: ColorManager.titleWhite,
          elevation: 0,
          leading: IconButton(
            onPressed: () =>
                Navigator.popUntil(context, (route) => route.isFirst),
            icon: Icon(Icons.close, color: ColorManager.darkForestGreen),
          ),
          title: CustomText(
            'حالة الحجز',
            color: ColorManager.darkForestGreen,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
          centerTitle: true,
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        Container(
                          width: 72,
                          height: 72,
                          decoration: BoxDecoration(
                            color: ColorManager.deepGreen,
                            shape: BoxShape.circle,
                          ),
                          alignment: Alignment.center,
                          child: const Icon(
                            Icons.check,
                            color: ColorManager.titleWhite,
                            size: 36,
                          ),
                        ),
                        const SizedBox(height: 18),
                        CustomText(
                          'تم تأكيد الحجز!',
                          color: ColorManager.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        const SizedBox(height: 6),
                        CustomText(
                          'تم تأكيد مكانك في ${event.title}.',
                          color: ColorManager.gray,
                          fontSize: 13,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),
                        TicketQrCard(
                          activityName: event.title,
                          date: event.date,
                          time: event.time,
                          bookingId: _bookingId,
                          seat: _seat,
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: CustomElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (_) => const SavedTicketDialog(),
                      );
                    },
                    backgroundColor: ColorManager.deepGreen,
                    foregroundColor: ColorManager.titleWhite,
                    radius: 28,
                    fixedSize: const Size(double.infinity, 56),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.download,
                          color: ColorManager.titleWhite,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        CustomText(
                          'حفظ التذكرة',
                          color: ColorManager.titleWhite,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
