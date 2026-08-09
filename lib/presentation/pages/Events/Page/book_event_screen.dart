import 'package:directorateofculture/Constant/color_manager.dart';
import 'package:directorateofculture/presentation/pages/Events/Page/booking_ticket_screen.dart';
import 'package:directorateofculture/presentation/pages/Events/Cubit/book_event_cubit.dart';
import 'package:directorateofculture/presentation/pages/Events/Cubit/book_event_state.dart';
import 'package:directorateofculture/presentation/pages/Events/Model/event_model.dart';
import 'package:directorateofculture/presentation/util/SnackBar.dart';
import 'package:directorateofculture/presentation/util/custom_container.dart';
import 'package:directorateofculture/presentation/util/custom_elevatedButton.dart';
import 'package:directorateofculture/presentation/util/custom_text.dart';
import 'package:directorateofculture/repositories/misc_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class BookEventScreen extends StatelessWidget {
  final ActivityCardModel activity;

  const BookEventScreen({super.key, required this.activity});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BookEventCubit(
        repository: MiscRepository(),
        activity: activity,
      ),
      child: const _BookEventView(),
    );
  }
}

class _BookEventView extends StatelessWidget {
  const _BookEventView();

  String _weekdayLabel(DateTime? date) {
    if (date == null) return '';
    return DateFormat('EEEE, MMM dd').format(date);
  }

  String _priceLabel(num? price) {
    if (price == null || price == 0) return 'دخول مجاني';
    return '$price ريال';
  }

  String _totalPriceLabel(num? price, int attendees) {
    if (price == null || price == 0) return 'دخول مجاني';
    final total = price * attendees;
    return '$total ريال';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.lightBackground,
      appBar: AppBar(
        backgroundColor: ColorManager.lightBackground,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back, color: ColorManager.darkForestGreen),
        ),
        title: CustomText(
          'حجز فعالية',
          fontSize: 18.sp,
          fontWeight: FontWeight.bold,
          color: ColorManager.darkForestGreen,
        ),
        centerTitle: true,
      ),
      body: BlocListener<BookEventCubit, BookEventState>(
        listener: (context, state) {
          if (state.isSuccess && state.reservationData != null) {
            // نجاح الحجز: ننتقل لشاشة التذكرة التي تولّد QR من qr_payload
            // الذي أرجعه الباك اند مع سجل الحجز (POST /reservations).
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (_) => BookingTicketScreen(
                  activity: state.activity,
                  reservation: state.reservationData!,
                ),
              ),
            );
          } else if (state.errorMessage != null) {
            AppSnackBar.show(context, state.errorMessage!, success: false);
          }
        },
        child: BlocBuilder<BookEventCubit, BookEventState>(
          builder: (context, state) {
            final activity = state.activity;

            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          'أكمل حجزك ببضع خطوات بسيطة',
                          fontSize: 13.sp,
                          color: ColorManager.gray,
                        ),
                        SizedBox(height: 20.h),

                        // ─── بطاقة الفعالية (بيانات حقيقية من الشاشة السابقة) ───
                        CustomContainer(
                          width: double.infinity,
                          color: ColorManager.titleWhite,
                          radius: 18.r,
                          paddingAll: 14,
                          shadowColor: ColorManager.black.withOpacity(0.05),
                          shadowBlurRadius: 10,
                          shadowOffset: const Offset(0, 4),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(14.r),
                                child: Image.network(
                                  activity.imageUrl,
                                  width: 72.w,
                                  height: 72.w,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Container(
                                    width: 72.w,
                                    height: 72.w,
                                    color:
                                        ColorManager.lightGray.withOpacity(0.3),
                                    alignment: Alignment.center,
                                    child: Icon(Icons.image_outlined,
                                        color: ColorManager.gray),
                                  ),
                                ),
                              ),
                              SizedBox(width: 14.w),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CustomText(
                                      activity.title,
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.bold,
                                      color: ColorManager.darkForestGreen,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(height: 8.h),
                                    Row(
                                      children: [
                                        Icon(Icons.calendar_today_outlined,
                                            size: 13.sp,
                                            color: ColorManager.gray),
                                        SizedBox(width: 6.w),
                                        Expanded(
                                          child: CustomText(
                                            activity.startTime != null
                                                ? '${_weekdayLabel(activity.startTime)} • ${activity.timeLabel}'
                                                : 'الموعد غير محدد',
                                            fontSize: 12.sp,
                                            color: ColorManager.gray,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 6.h),
                                    Row(
                                      children: [
                                        Icon(Icons.location_on_outlined,
                                            size: 13.sp,
                                            color: ColorManager.gray),
                                        SizedBox(width: 6.w),
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
                                    SizedBox(height: 10.h),
                                    CustomContainer(
                                      color: ColorManager.lightGreen
                                          .withOpacity(0.4),
                                      radius: 20.r,
                                      paddingHorizontal: 10,
                                      paddingVertical: 4,
                                      child: CustomText(
                                        activity.capacity == null
                                            ? 'مقاعد غير محدودة'
                                            : '${state.seatsAvailable} seats available',
                                        fontSize: 11.sp,
                                        fontWeight: FontWeight.w600,
                                        color: ColorManager.deepGreen,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 16.h),

                        // ─── بطاقة عدد الحضور ───
                        CustomContainer(
                          width: double.infinity,
                          color: ColorManager.titleWhite,
                          radius: 18.r,
                          paddingAll: 16,
                          shadowColor: ColorManager.black.withOpacity(0.05),
                          shadowBlurRadius: 10,
                          shadowOffset: const Offset(0, 4),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomText(
                                    'عدد الحضور',
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.bold,
                                    color: ColorManager.black,
                                  ),
                                  SizedBox(height: 4.h),
                                  CustomText(
                                    'الحد الأقصى ${state.maxGuests} أشخاص',
                                    fontSize: 12.sp,
                                    color: ColorManager.gray,
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  _StepperButton(
                                    icon: Icons.remove,
                                    backgroundColor:
                                        ColorManager.lightGray.withOpacity(0.3),
                                    iconColor: ColorManager.darkForestGreen,
                                    onTap: () =>
                                        context.read<BookEventCubit>().decrement(),
                                  ),
                                  SizedBox(width: 16.w),
                                  CustomText(
                                    '${state.attendees}',
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600,
                                    color: ColorManager.black,
                                  ),
                                  SizedBox(width: 16.w),
                                  _StepperButton(
                                    icon: Icons.add,
                                    backgroundColor: ColorManager.darkForestGreen,
                                    iconColor: ColorManager.titleWhite,
                                    onTap: () =>
                                        context.read<BookEventCubit>().increment(),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 16.h),

                        // ─── ملخص التذكرة ───
                        CustomContainer(
                          width: double.infinity,
                          color: ColorManager.lightBackground,
                          radius: 16.r,
                          paddingAll: 18,
                          borderColor: ColorManager.lightGray.withOpacity(0.4),
                          borderWidth: 1,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CustomText(
                                'الإجمالي لـ ${state.attendees} تذكرة',
                                fontSize: 14.sp,
                                color: ColorManager.black,
                              ),
                              CustomText(
                                _totalPriceLabel(activity.ticketPrice, state.attendees),
                                fontSize: 15.sp,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFFB8860B),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 20.h),
                      ],
                    ),
                  ),
                ),

                // ─── زر تأكيد الحجز الثابت أسفل الشاشة ───
                Padding(
                  padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 20.h),
                  child: SizedBox(
                    width: double.infinity,
                    child: CustomElevatedButton(
                      onPressed: state.isSubmitting
                          ? null
                          : () => context.read<BookEventCubit>().confirmBooking(),
                      backgroundColor: ColorManager.darkForestGreen,
                      radius: 28.r,
                      fixedSize: Size(double.infinity, 56.h),
                      child: state.isSubmitting
                          ? SizedBox(
                              width: 22.w,
                              height: 22.w,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.2,
                                color: ColorManager.titleWhite,
                              ),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CustomText(
                                  'تأكيد الحجز',
                                  color: ColorManager.titleWhite,
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                                SizedBox(width: 8.w),
                                Icon(
                                  Icons.check_circle_outline,
                                  color: ColorManager.titleWhite,
                                  size: 18.sp,
                                ),
                              ],
                            ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _StepperButton extends StatelessWidget {
  final IconData icon;
  final Color backgroundColor;
  final Color iconColor;
  final VoidCallback onTap;

  const _StepperButton({
    required this.icon,
    required this.backgroundColor,
    required this.iconColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: CustomContainer(
        width: 32.w,
        height: 32.h,
        color: backgroundColor,
        shape: BoxShape.circle,
        alignment: Alignment.center,
        child: Icon(icon, size: 16.sp, color: iconColor),
      ),
    );
  }
}