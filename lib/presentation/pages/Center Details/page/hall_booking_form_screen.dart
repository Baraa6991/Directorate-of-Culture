import 'package:directorateofculture/Constant/color_manager.dart';
import 'package:directorateofculture/presentation/pages/Center%20Details/page/hall_booking_success_screen.dart';
import 'package:directorateofculture/presentation/pages/Center%20Details/widget/Cubit/hall_booking_form_cubit.dart';
import 'package:directorateofculture/presentation/pages/Center%20Details/widget/Cubit/hall_booking_form_state.dart';
import 'package:directorateofculture/presentation/util/SnackBar.dart';
import 'package:directorateofculture/repositories/misc_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart' as intl;
import 'package:flutter_screenutil/flutter_screenutil.dart';


class HallBookingFormScreen extends StatelessWidget {
  final String venueId;

  const HallBookingFormScreen({
    super.key,
    required this.venueId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HallBookingFormCubit(
        repository: MiscRepository(),
      ),
      child: _HallBookingFormView(venueId: venueId),
    );
  }
}

class _HallBookingFormView extends StatefulWidget {
  final String venueId;

  const _HallBookingFormView({required this.venueId});

  @override
  State<_HallBookingFormView> createState() => _HallBookingFormViewState();
}

class _HallBookingFormViewState extends State<_HallBookingFormView> {
  final TextEditingController _requestingPartyController = TextEditingController();
  final TextEditingController _applicantNameController = TextEditingController();
  final TextEditingController _nationalIdController = TextEditingController();
  final TextEditingController _reservationReasonController = TextEditingController();
  final TextEditingController _eventDescriptionController = TextEditingController();

  @override
  void dispose() {
    _requestingPartyController.dispose();
    _applicantNameController.dispose();
    _nationalIdController.dispose();
    _reservationReasonController.dispose();
    _eventDescriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickDateTime({required bool isStart}) async {
    final cubit = context.read<HallBookingFormCubit>();
    final now = DateTime.now();

    final selectedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now.subtract(const Duration(days: 365)),
      lastDate: now.add(const Duration(days: 3650)),
    );

    if (selectedDate == null || !mounted) return;

    final selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(now),
    );

    if (selectedTime == null) return;

    final dateTime = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      selectedTime.hour,
      selectedTime.minute,
    );

    if (isStart) {
      cubit.updateStartDateTime(dateTime);
    } else {
      cubit.updateEndDateTime(dateTime);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7F8),
      body: SafeArea(
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: BlocListener<HallBookingFormCubit, HallBookingFormState>(
            listener: (context, state) {
              if (state.isSuccess && state.successMessage != null) {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (_) => HallBookingSuccessScreen(
                      message: state.successMessage!,
                    ),
                  ),
                );
              } else if (state.errorMessage != null) {
                AppSnackBar.show(context, state.errorMessage!, success: false);
              }
            },
            child: BlocBuilder<HallBookingFormCubit, HallBookingFormState>(
              builder: (context, state) {
                return SingleChildScrollView(
                  padding: EdgeInsets.all(16.r),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 24,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const _BookingHeader(activeStep: 2),
                          SizedBox(height: 18.h),
                          const _SectionTitle(
                            title: 'بيانات الطلب',
                            subtitle: 'تفاصيل الجهة والفعالية',
                          ),
                          SizedBox(height: 14.h),
                          _InputField(
                            label: 'اسم الجهة الطالبة',
                            hint: 'ادخل اسم الجهة الطالبة',
                            icon: Icons.apartment_outlined,
                            controller: _requestingPartyController,
                            onChanged: context.read<HallBookingFormCubit>().updateRequestingParty,
                          ),
                          _InputField(
                            label: 'مقدم الطلب',
                            hint: 'ادخل اسم مقدم الطلب',
                            icon: Icons.person_outline_rounded,
                            controller: _applicantNameController,
                            onChanged: context.read<HallBookingFormCubit>().updateApplicantName,
                          ),
                          _InputField(
                            label: 'الرقم الوطني',
                            hint: 'ادخل الرقم الوطني',
                            icon: Icons.badge_outlined,
                            controller: _nationalIdController,
                            keyboardType: TextInputType.number,
                            onChanged: context.read<HallBookingFormCubit>().updateNationalIdNumber,
                          ),
                          _InputField(
                            label: 'سبب الحجز',
                            hint: 'ادخل سبب الحجز',
                            icon: Icons.edit_note_rounded,
                            controller: _reservationReasonController,
                            onChanged: context.read<HallBookingFormCubit>().updateReservationReason,
                          ),
                          _InputField(
                            label: 'وصف الفعالية',
                            hint: 'ادخل وصف الفعالية',
                            icon: null,
                            maxLines: 4,
                            controller: _eventDescriptionController,
                            onChanged: context.read<HallBookingFormCubit>().updateEventDescription,
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            'نوع الفعالية',
                            style: TextStyle(
                              color: Color(0xFF262B30),
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(height: 10.h),
                          Row(
                            children: [
                              Expanded(
                                child: _EventTypeCard(
                                  title: 'عامة',
                                  icon: Icons.groups_2_outlined,
                                  selected: state.isPublic,
                                  onTap: () {
                                    context.read<HallBookingFormCubit>().updateIsPublic(true);
                                  },
                                ),
                              ),
                              SizedBox(width: 10.w),
                              Expanded(
                                child: _EventTypeCard(
                                  title: 'خاصة',
                                  icon: Icons.lock_outline_rounded,
                                  selected: !state.isPublic,
                                  onTap: () {
                                    context.read<HallBookingFormCubit>().updateIsPublic(false);
                                  },
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 14.h),
                          _DateTimeSection(
                            title: 'وقت البدء',
                            dateTime: state.startDateTime,
                            onPick: () => _pickDateTime(isStart: true),
                          ),
                          SizedBox(height: 14.h),
                          _DateTimeSection(
                            title: 'وقت الانتهاء',
                            dateTime: state.endDateTime,
                            onPick: () => _pickDateTime(isStart: false),
                          ),
                          SizedBox(height: 20.h),
                          SizedBox(
                            height: 52.h,
                            child: OutlinedButton(
                              onPressed: () => Navigator.of(context).pop(),
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: Color(0xFF93BEA0)),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                              ),
                              child: Text(
                                'السابق',
                                style: TextStyle(
                                  color: ColorManager.deepGreen,
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 10.h),
                          SizedBox(
                            height: 52.h,
                            child: ElevatedButton(
                              onPressed: state.isSubmitting
                                  ? null
                                  : () {
                                      context.read<HallBookingFormCubit>().submit(
                                            venueId: widget.venueId,
                                          );
                                    },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: ColorManager.deepGreen,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                                elevation: 0,
                              ),
                              child: state.isSubmitting
                                  ? SizedBox(
                                      width: 22.w,
                                      height: 22.h,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    )
                                  : Text(
                                      'إرسال الطلب',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _BookingHeader extends StatelessWidget {
  final int activeStep;

  const _BookingHeader({required this.activeStep});

  @override
  Widget build(BuildContext context) {
    final isStepOneActive = activeStep == 1;

    return Column(
      children: [
        Row(
          children: [
            IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: ColorManager.deepGreen,
              ),
            ),
            Expanded(
              child: Center(
                child: Text(
                  'طلب حجز قاعة',
                  style: TextStyle(
                    fontSize: 36.sp,
                    fontWeight: FontWeight.w700,
                    color: ColorManager.deepGreen,
                  ),
                ),
              ),
            ),
            SizedBox(width: 48.w),
          ],
        ),
        SizedBox(height: 8.h),
        Row(
          children: [
            Expanded(
              child: _StepNode(
                index: 1,
                title: 'بيانات القاعة',
                active: isStepOneActive,
              ),
            ),
            Container(
              height: 2.h,
              width: 100.w,
              color: const Color(0xFFD7DBDE),
            ),
            Expanded(
              child: _StepNode(
                index: 2,
                title: 'بيانات الطلب',
                active: !isStepOneActive,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _StepNode extends StatelessWidget {
  final int index;
  final String title;
  final bool active;

  const _StepNode({
    required this.index,
    required this.title,
    required this.active,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 32.h,
          width: 32.w,
          decoration: BoxDecoration(
            color: active ? ColorManager.deepGreen : const Color(0xFFD5D8DD),
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Text(
            '$index',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        SizedBox(height: 6.h),
        Text(
          title,
          style: TextStyle(
            color: active ? ColorManager.deepGreen : const Color(0xFF9CA3AB),
            fontSize: 14.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final String subtitle;

  const _SectionTitle({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          style: TextStyle(
            color: Color(0xFF20242A),
            fontSize: 38.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          subtitle,
          style: TextStyle(
            color: Color(0xFF939AA3),
            fontSize: 24.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _InputField extends StatelessWidget {
  final String label;
  final String hint;
  final IconData? icon;
  final int maxLines;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final ValueChanged<String>? onChanged;

  const _InputField({
    required this.label,
    required this.hint,
    required this.icon,
    required this.controller,
    this.onChanged,
    this.keyboardType,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Color(0xFF262B30),
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 8.h),
          TextField(
            controller: controller,
            onChanged: onChanged,
            keyboardType: keyboardType,
            maxLines: maxLines,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(
                color: Color(0xFFB3BAC1),
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
              filled: true,
              fillColor: Colors.white,
              suffixIcon: icon == null
                  ? null
                  : Icon(icon, color: const Color(0xFF4F555B)),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: const BorderSide(color: Color(0xFFE1E5E9)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: const BorderSide(color: Color(0xFFE1E5E9)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: const BorderSide(color: ColorManager.deepGreen),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EventTypeCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _EventTypeCard({
    required this.title,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        height: 86.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: selected ? const Color(0xFF7DB08D) : const Color(0xFFE2E6EA),
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    icon,
                    size: 24.sp,
                    color: selected
                        ? ColorManager.deepGreen
                        : const Color(0xFF9AA0A7),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    title,
                    style: TextStyle(
                      color: selected
                          ? ColorManager.deepGreen
                          : const Color(0xFF9AA0A7),
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            if (selected)
              Positioned(
                top: 8.h,
                left: 8.w,
                child: Icon(
                  Icons.check_circle,
                  color: ColorManager.deepGreen,
                  size: 18.sp,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _DateTimeSection extends StatelessWidget {
  final String title;
  final DateTime? dateTime;
  final VoidCallback onPick;

  const _DateTimeSection({
    required this.title,
    required this.dateTime,
    required this.onPick,
  });

  @override
  Widget build(BuildContext context) {
    final date = dateTime == null
      ? 'اختر التاريخ والوقت'
      : intl.DateFormat('yyyy-MM-dd HH:mm').format(dateTime!);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: Color(0xFF262B30),
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: 8.h),
        InkWell(
          onTap: onPick,
          borderRadius: BorderRadius.circular(12.r),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 15.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: const Color(0xFFE1E5E9)),
            ),
            child: Row(
              children: [
                const Icon(Icons.calendar_month_outlined, color: Color(0xFF4F555B)),
                SizedBox(width: 10.w),
                Expanded(
                  child: Text(
                    date,
                    style: TextStyle(
                      color: dateTime == null ? const Color(0xFFB3BAC1) : const Color(0xFF1F242A),
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
