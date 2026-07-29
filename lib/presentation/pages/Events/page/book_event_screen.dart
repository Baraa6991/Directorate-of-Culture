import 'package:directorateofculture/Constant/color_manager.dart';
import 'package:directorateofculture/presentation/pages/Events/widget/book_event_cubit.dart';
import 'package:directorateofculture/presentation/pages/Events/widget/book_event_state.dart';
import 'package:directorateofculture/presentation/pages/Events/widget/event_model.dart';
import 'package:directorateofculture/presentation/util/attendee_stepper.dart';
import 'package:directorateofculture/presentation/util/custom_container.dart';
import 'package:directorateofculture/presentation/util/custom_elevatedButton.dart';
import 'package:directorateofculture/presentation/util/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'booking_success_screen.dart';

class BookEventScreen extends StatelessWidget {
  final EventModel event;

  const BookEventScreen({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: BlocProvider(
        create: (_) => BookEventCubit(),
        child: Scaffold(
          backgroundColor: ColorManager.titleWhite,
          // AppBar matches the existing app convention for form/status
          // screens (see ConfirmBookingScreen / VolunteerFormScreen).
          appBar: AppBar(
            backgroundColor: ColorManager.titleWhite,
            elevation: 0,
            leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(Icons.arrow_back, color: ColorManager.darkForestGreen),
            ),
            title: CustomText(
              'حجز الفعالية',
              color: ColorManager.darkForestGreen,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            centerTitle: true,
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  CustomText(
                    'أكمل حجزك بخطوات بسيطة',
                    color: ColorManager.gray,
                    fontSize: 13,
                  ),
                  const SizedBox(height: 20),
                  CustomContainer(
                    width: double.infinity,
                    color: ColorManager.lightBackground,
                    radius: 18,
                    paddingAll: 14,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.asset(
                            event.imageAsset,
                            width: 64,
                            height: 64,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText(
                                event.title,
                                color: ColorManager.deepGreen,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  Icon(
                                    Icons.calendar_today,
                                    size: 12,
                                    color: ColorManager.gray,
                                  ),
                                  const SizedBox(width: 4),
                                  CustomText(
                                    '${event.date}, ${event.time}',
                                    color: ColorManager.gray,
                                    fontSize: 12,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Icon(
                                    Icons.location_on_outlined,
                                    size: 12,
                                    color: ColorManager.gray,
                                  ),
                                  const SizedBox(width: 4),
                                  CustomText(
                                    event.location,
                                    color: ColorManager.gray,
                                    fontSize: 12,
                                  ),
                                ],
                              ),
                              if (event.seatsAvailable != null) ...[
                                const SizedBox(height: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: ColorManager.lightGreen.withOpacity(
                                      0.35,
                                    ),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: CustomText(
                                    '${event.seatsAvailable} مقعد متاح',
                                    color: ColorManager.darkForestGreen,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  CustomContainer(
                    width: double.infinity,
                    color: ColorManager.lightBackground,
                    radius: 18,
                    paddingAll: 16,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                              'عدد الحضور',
                              color: ColorManager.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                            const SizedBox(height: 2),
                            CustomText(
                              'الحد الأقصى 10 ضيوف',
                              color: ColorManager.gray,
                              fontSize: 12,
                            ),
                          ],
                        ),
                        BlocBuilder<BookEventCubit, BookEventState>(
                          builder: (context, state) {
                            return AttendeeStepper(
                              value: state.attendeeCount,
                              onChanged: context
                                  .read<BookEventCubit>()
                                  .setAttendeeCount,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  BlocBuilder<BookEventCubit, BookEventState>(
                    builder: (context, state) {
                      return CustomContainer(
                        width: double.infinity,
                        color: ColorManager.lightBackground,
                        radius: 18,
                        paddingAll: 16,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomText(
                              '${state.attendeeCount} تذكرة',
                              color: ColorManager.black,
                              fontSize: 14,
                            ),
                            CustomText(
                              event.isFreeEntry ? 'دخول مجاني' : 'دخول مدفوع',
                              color: ColorManager.liveBadge,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    child: BlocBuilder<BookEventCubit, BookEventState>(
                      builder: (context, state) {
                        return CustomElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) => BookingSuccessScreen(
                                  event: event,
                                  attendeeCount: state.attendeeCount,
                                ),
                              ),
                            );
                          },
                          backgroundColor: ColorManager.deepGreen,
                          foregroundColor: ColorManager.titleWhite,
                          radius: 28,
                          fixedSize: const Size(double.infinity, 56),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CustomText(
                                'تأكيد الحجز',
                                color: ColorManager.titleWhite,
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                              const SizedBox(width: 8),
                              const Icon(
                                Icons.check_circle_outline,
                                color: ColorManager.titleWhite,
                                size: 18,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
