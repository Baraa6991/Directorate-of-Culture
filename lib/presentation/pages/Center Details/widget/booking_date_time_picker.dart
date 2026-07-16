import 'package:directorateofculture/Constant/color_manager.dart';
import 'package:directorateofculture/presentation/util/custom_container.dart';
import 'package:directorateofculture/presentation/util/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:table_calendar/table_calendar.dart';
import 'booking_cubit.dart';
import 'booking_state.dart';

class BookingDateTimePicker extends StatelessWidget {
  const BookingDateTimePicker({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      width: double.infinity,
      color: ColorManager.titleWhite,
      radius: 24,
      paddingAll: 20,
      shadowColor: Colors.black.withOpacity(0.06),
      shadowBlurRadius: 12,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            'Select Date',
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: ColorManager.black,
          ),
          const SizedBox(height: 8),
          _CalendarSection(),
          const SizedBox(height: 20),
          CustomText(
            'Available Time Slots',
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: ColorManager.black,
          ),
          const SizedBox(height: 12),
          _TimeSlotsGrid(), // يدوي كما طلبت
        ],
      ),
    );
  }
}

// ─── قسم التقويم عبر table_calendar ────────────────────────
class _CalendarSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookingCubit, BookingState>(
      builder: (context, state) {
        final cubit = context.read<BookingCubit>();

        return TableCalendar(
          firstDay: DateTime.now().subtract(const Duration(days: 1)),
          lastDay: DateTime.now().add(const Duration(days: 365)),
          focusedDay: state.focusedDay,
          selectedDayPredicate: (day) =>
              state.selectedDate != null && isSameDay(state.selectedDate, day),
          onDaySelected: cubit.selectDate,
          onPageChanged: cubit.onPageChanged,
          startingDayOfWeek: StartingDayOfWeek.sunday,

          // ─── إخفاء عنوان table_calendar الافتراضي (عندنا Select Date فوق) ───
          headerStyle: HeaderStyle(
            titleCentered: false,
            formatButtonVisible: false,
            leftChevronIcon: const Icon(Icons.chevron_left, size: 22),
            rightChevronIcon: const Icon(Icons.chevron_right, size: 22),
            titleTextStyle: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: ColorManager.black,
            ),
            headerPadding: EdgeInsets.zero,
          ),

          daysOfWeekStyle: DaysOfWeekStyle(
            weekdayStyle: TextStyle(
              color: ColorManager.gray,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
            weekendStyle: TextStyle(
              color: ColorManager.gray,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),

          // ─── التصميم المطابق لتصميمك بالضبط ─────────────
          calendarStyle: CalendarStyle(
            outsideDaysVisible: true,
            outsideTextStyle: TextStyle(color: ColorManager.lightGray),
            defaultTextStyle: TextStyle(color: ColorManager.black),
            weekendTextStyle: TextStyle(color: ColorManager.black),

            // ─── مهم: يجب توحيد shape على "rectangle" في كل الحالات ───
            // table_calendar يستخدم AnimatedContainer للانتقال بين الحالات
            // (عادي ↔ محدد ↔ اليوم الحالي). لو بقيت أي حالة على القيمة
            // الافتراضية (BoxShape.circle) بينما حالات أخرى مربعة، فإن
            // Flutter يحاول عمل Tween بين دائرة ومربع بحواف دائرية، وهذا
            // يسبب خطأ "A circle cannot have a border radius" في لحظة
            // الانتقال. لذلك كل الديكورات هنا rectangle بلا استثناء.
            defaultDecoration: const BoxDecoration(shape: BoxShape.rectangle),
            weekendDecoration: const BoxDecoration(shape: BoxShape.rectangle),
            holidayDecoration: const BoxDecoration(shape: BoxShape.rectangle),
            outsideDecoration: const BoxDecoration(shape: BoxShape.rectangle),
            disabledDecoration:
                const BoxDecoration(shape: BoxShape.rectangle),
            rangeStartDecoration:
                const BoxDecoration(shape: BoxShape.rectangle),
            rangeEndDecoration: const BoxDecoration(shape: BoxShape.rectangle),
            withinRangeDecoration:
                const BoxDecoration(shape: BoxShape.rectangle),

            todayDecoration: BoxDecoration(
              border: Border.all(color: ColorManager.darkForestGreen),
              borderRadius: BorderRadius.circular(10),
              shape: BoxShape.rectangle,
            ),
            todayTextStyle: TextStyle(color: ColorManager.black),

            selectedDecoration: BoxDecoration(
              color: ColorManager.darkForestGreen,
              borderRadius: BorderRadius.circular(10),
              shape: BoxShape.rectangle,
            ),
            selectedTextStyle: TextStyle(
              color: ColorManager.titleWhite,
              fontWeight: FontWeight.bold,
            ),

            cellMargin: const EdgeInsets.all(4),
          ),
        );
      },
    );
  }
}

// ─── شبكة الأوقات — يدوية بالكامل كما طلبت ─────────────────
class _TimeSlotsGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookingCubit, BookingState>(
      builder: (context, state) {
        final cubit = context.read<BookingCubit>();

        if (state.availableTimes.isEmpty) {
          return CustomText(
            'No available time slots',
            fontSize: 13,
            color: ColorManager.gray,
          );
        }

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: state.availableTimes.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 2.6, // تحكم بنسبة العرض للارتفاع هنا
          ),
          itemBuilder: (context, index) {
            final time = state.availableTimes[index];
            final isSelected = state.selectedTime == time;
            return GestureDetector(
              onTap: () => cubit.selectTime(time),
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isSelected
                      ? ColorManager.darkForestGreen
                      : ColorManager.lightBackground,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: CustomText(
                  time,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isSelected
                      ? ColorManager.titleWhite
                      : ColorManager.black,
                ),
              ),
            );
          },
        );
      },
    );
  }
}