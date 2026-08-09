import 'package:directorateofculture/Constant/color_manager.dart';
import 'package:directorateofculture/presentation/pages/Events/Page/event_details_screen.dart';
import 'package:directorateofculture/presentation/pages/Reservations/Cubit/reservations_archive_cubit.dart';
import 'package:directorateofculture/presentation/pages/Reservations/Cubit/reservations_archive_state.dart';
import 'package:directorateofculture/presentation/pages/Reservations/Model/reservation_model.dart';
import 'package:directorateofculture/presentation/util/custom_container.dart';
import 'package:directorateofculture/presentation/util/custom_elevatedButton.dart';
import 'package:directorateofculture/presentation/util/custom_text.dart';
import 'package:directorateofculture/repositories/misc_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qr_flutter/qr_flutter.dart';

/// شاشة "أرشيف الحجوزات" — تعرض فعاليات المستخدم المحجوزة فقط (بدون مراكز
/// ثقافية) موزّعة على 4 تبويبات: مكتملة / غير مكتملة / غير مدفوعة / ملغاة.
class ReservationsArchiveScreen extends StatelessWidget {
  const ReservationsArchiveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          ReservationsArchiveCubit(repository: MiscRepository())..loadFirstPage(),
      child: const _ReservationsArchiveView(),
    );
  }
}

class _ReservationsArchiveView extends StatefulWidget {
  const _ReservationsArchiveView();

  @override
  State<_ReservationsArchiveView> createState() => _ReservationsArchiveViewState();
}

class _ReservationsArchiveViewState extends State<_ReservationsArchiveView> {
  final ScrollController _scrollController = ScrollController();

  static const _tabs = [
    (ReservationArchiveStatus.completed, 'مكتملة'),
    (ReservationArchiveStatus.incomplete, 'غير مكتملة'),
    (ReservationArchiveStatus.unpaid, 'غير مدفوعة'),
    (ReservationArchiveStatus.cancelled, 'ملغاة'),
  ];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final threshold = _scrollController.position.maxScrollExtent - 300;
    if (_scrollController.position.pixels >= threshold) {
      context.read<ReservationsArchiveCubit>().loadNextPage();
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ReservationsArchiveCubit>();

    return Scaffold(
      backgroundColor: ColorManager.lightBackground,
      appBar: AppBar(
        backgroundColor: ColorManager.lightBackground,
        elevation: 0,
        iconTheme: const IconThemeData(color: ColorManager.black),
        title: CustomText(
          'أرشيف الحجوزات',
          color: ColorManager.deepGreen,
          fontSize: 18.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: Column(
        children: [
          // ─── التبويبات الأربعة ───
          SizedBox(
            height: 46.h,
            child: BlocBuilder<ReservationsArchiveCubit, ReservationsArchiveState>(
              buildWhen: (prev, curr) => prev.activeTab != curr.activeTab,
              builder: (context, state) {
                return ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  itemCount: _tabs.length,
                  separatorBuilder: (_, __) => SizedBox(width: 8.w),
                  itemBuilder: (context, index) {
                    final (status, label) = _tabs[index];
                    final isActive = state.activeTab == status;

                    return GestureDetector(
                      onTap: () => cubit.changeTab(status),
                      child: CustomContainer(
                        color: isActive
                            ? ColorManager.deepGreen
                            : ColorManager.titleWhite,
                        radius: 20.r,
                        paddingHorizontal: 16,
                        alignment: Alignment.center,
                        child: CustomText(
                          label,
                          color: isActive
                              ? ColorManager.titleWhite
                              : ColorManager.black,
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          SizedBox(height: 12.h),

          // ─── قائمة الحجوزات ───
          Expanded(
            child: BlocConsumer<ReservationsArchiveCubit, ReservationsArchiveState>(
              listenWhen: (prev, curr) => prev.items.length > curr.items.length,
              listener: (context, state) {}, // متروكة عمداً؛ يمكن ربط SnackBar تأكيد لاحقاً
              builder: (context, state) {
                if (state.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state.errorMessage != null && state.items.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomText(
                          state.errorMessage!,
                          color: ColorManager.gray,
                          fontSize: 13.sp,
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 10.h),
                        TextButton(
                          onPressed: cubit.loadFirstPage,
                          child: const CustomText(
                            'إعادة المحاولة',
                            color: ColorManager.deepGreen,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                if (state.items.isEmpty) {
                  return Center(
                    child: CustomText(
                      'لا توجد حجوزات هنا',
                      color: ColorManager.gray,
                      fontSize: 14.sp,
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: cubit.loadFirstPage,
                  child: ListView.separated(
                    controller: _scrollController,
                    padding: EdgeInsets.all(16.w),
                    itemCount:
                        state.items.length + (state.isLoadingMore ? 1 : 0),
                    separatorBuilder: (_, __) => SizedBox(height: 14.h),
                    itemBuilder: (context, index) {
                      if (index >= state.items.length) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(12),
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        );
                      }
                      return _ReservationCard(reservation: state.items[index]);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ReservationCard extends StatelessWidget {
  final ReservationModel reservation;
  const _ReservationCard({required this.reservation});

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      color: ColorManager.titleWhite,
      radius: 18.r,
      paddingAll: 14,
      shadowColor: ColorManager.black.withOpacity(0.05),
      shadowBlurRadius: 8,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12.r),
                child: reservation.activityImage != null
                    ? Image.network(
                        reservation.activityImage!,
                        width: 72.w,
                        height: 72.w,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => _placeholderImage(),
                      )
                    : _placeholderImage(),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _StatusBadge(status: reservation.archiveStatus),
                    SizedBox(height: 6.h),
                    CustomText(
                      reservation.activityTitle,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      color: ColorManager.black,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4.h),
                    Row(
                      children: [
                        Icon(Icons.calendar_today_outlined,
                            size: 12.sp, color: ColorManager.gray),
                        SizedBox(width: 4.w),
                        CustomText(
                          '${reservation.dateLabel} • ${reservation.timeLabel}',
                          fontSize: 11.sp,
                          color: ColorManager.gray,
                        ),
                      ],
                    ),
                    if (reservation.locationLabel != null) ...[
                      SizedBox(height: 2.h),
                      Row(
                        children: [
                          Icon(Icons.location_on_outlined,
                              size: 12.sp, color: ColorManager.gray),
                          SizedBox(width: 4.w),
                          Expanded(
                            child: CustomText(
                              reservation.locationLabel!,
                              fontSize: 11.sp,
                              color: ColorManager.gray,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          _ActionsRow(reservation: reservation),
        ],
      ),
    );
  }

  Widget _placeholderImage() {
    return Container(
      width: 72.w,
      height: 72.w,
      color: ColorManager.lightGray.withOpacity(0.3),
      alignment: Alignment.center,
      child: Icon(Icons.event, color: ColorManager.gray, size: 20.sp),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final ReservationArchiveStatus status;
  const _StatusBadge({required this.status});

  (Color, Color, String) get _style {
    switch (status) {
      case ReservationArchiveStatus.completed:
        return (ColorManager.lightGreen.withOpacity(0.3), ColorManager.deepGreen, 'مكتملة');
      case ReservationArchiveStatus.incomplete:
        return (const Color(0xFFFFF3C2), const Color(0xFF8A6D00), 'غير مكتملة');
      case ReservationArchiveStatus.unpaid:
        return (const Color(0xFFFFE0E0), const Color(0xFFB3261E), 'غير مدفوعة');
      case ReservationArchiveStatus.cancelled:
        return (ColorManager.lightGray.withOpacity(0.3), ColorManager.gray, 'ملغاة');
    }
  }

  @override
  Widget build(BuildContext context) {
    final (bg, fg, label) = _style;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 3.h),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(20.r)),
      child: CustomText(label, color: fg, fontSize: 10.sp, fontWeight: FontWeight.w700),
    );
  }
}

class _ActionsRow extends StatelessWidget {
  final ReservationModel reservation;
  const _ActionsRow({required this.reservation});

  @override
  Widget build(BuildContext context) {
    switch (reservation.archiveStatus) {
      // مكتملة: فقط عرض تفاصيل الفعالية، لا حاجة لرمز أو إلغاء بعد الحضور
      case ReservationArchiveStatus.completed:
        return SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => EventDetailsScreen(activityId: reservation.activityId),
              ),
            ),
            child: const CustomText('عرض تفاصيل الفعالية', color: ColorManager.deepGreen),
          ),
        );

      // غير مكتملة / غير مدفوعة: يسمح بعرض رمز QR والإلغاء (يُرجع المقاعد)
      case ReservationArchiveStatus.incomplete:
      case ReservationArchiveStatus.unpaid:
        return Row(
          children: [
            Expanded(
              child: CustomElevatedButton(
                backgroundColor: ColorManager.deepGreen,
                radius: 10.r,
                paddingVertical: 10,
                onPressed: () => _showQrSheet(context),
                child: CustomText('عرض رمز التذكرة',
                    color: ColorManager.titleWhite, fontSize: 12.sp, fontWeight: FontWeight.w600),
              ),
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.red),
                  padding: EdgeInsets.symmetric(vertical: 10.h),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
                ),
                onPressed: () => _confirmCancel(context),
                child: CustomText('إلغاء الحجز',
                    color: Colors.red, fontSize: 12.sp, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        );

      // ملغاة: لا إجراء متاح، فقط عرض تفاصيل الفعالية للاطلاع
      case ReservationArchiveStatus.cancelled:
        return SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => EventDetailsScreen(activityId: reservation.activityId),
              ),
            ),
            child: const CustomText('عرض تفاصيل الفعالية', color: ColorManager.gray),
          ),
        );
    }
  }

  void _showQrSheet(BuildContext context) {
    final qrData = (reservation.qrPayload?.trim().isNotEmpty == true)
        ? reservation.qrPayload!
        : reservation.ticketId;

    showModalBottomSheet(
      context: context,
      backgroundColor: ColorManager.titleWhite,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (_) {
        return Padding(
          padding: EdgeInsets.all(24.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomText(
                reservation.activityTitle,
                fontSize: 15.sp,
                fontWeight: FontWeight.bold,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 6.h),
              CustomText(
                'رقم التذكرة: ${reservation.ticketId}',
                fontSize: 12.sp,
                color: ColorManager.gray,
              ),
              SizedBox(height: 20.h),
              Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: ColorManager.titleWhite,
                  border: Border.all(color: ColorManager.lightGray.withOpacity(0.4)),
                  borderRadius: BorderRadius.circular(14.r),
                ),
                child: QrImageView(
                  data: qrData,
                  version: QrVersions.auto,
                  size: 200.w,
                  backgroundColor: ColorManager.titleWhite,
                ),
              ),
              SizedBox(height: 16.h),
              if (reservation.archiveStatus == ReservationArchiveStatus.unpaid)
                CustomText(
                  'هذه الفعالية مدفوعة — الدفع يتم عند الحضور ومسح هذا الرمز',
                  fontSize: 11.sp,
                  color: ColorManager.gray,
                  textAlign: TextAlign.center,
                ),
              SizedBox(height: 8.h),
              CustomText(
                'اعرض هذا الرمز عند مدخل الفعالية',
                fontSize: 11.sp,
                color: ColorManager.gray,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      },
    );
  }

  void _confirmCancel(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const CustomText('تأكيد الإلغاء'),
        content: const CustomText(
          'هل أنت متأكد من إلغاء هذا الحجز؟ سيتم إرجاع مقاعدك المحجوزة.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const CustomText('تراجع', color: ColorManager.gray),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(dialogContext);
              try {
                await context.read<ReservationsArchiveCubit>().cancel(reservation);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: CustomText('تم إلغاء الحجز بنجاح', color: ColorManager.titleWhite)),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(e.toString().replaceAll('Exception: ', ''))),
                  );
                }
              }
            },
            child: const CustomText('نعم، إلغاء', color: Colors.red),
          ),
        ],
      ),
    );
  }
}
