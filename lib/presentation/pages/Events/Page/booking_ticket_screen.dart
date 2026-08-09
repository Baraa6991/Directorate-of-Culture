import 'package:directorateofculture/Constant/assets_manager.dart';
import 'package:directorateofculture/Constant/color_manager.dart';
import 'package:directorateofculture/presentation/pages/Events/Model/event_model.dart';
import 'package:directorateofculture/presentation/pages/Home/page/home_page_screen.dart';
import 'package:directorateofculture/presentation/util/custom_container.dart';
import 'package:directorateofculture/presentation/util/custom_elevatedButton.dart';
import 'package:directorateofculture/presentation/util/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

/// شاشة "حالة الحجز" — تُعرض بعد نجاح الحجز، وتحتوي على تذكرة الفعالية
/// مع كود QR مأخوذ مباشرة من حمولة qr_payload التي يولّدها الباك اند
/// (Reservation::generateQrPayload) عند إنشاء السجل.
class BookingTicketScreen extends StatelessWidget {
  final ActivityCardModel activity;

  /// كائن الحجز كما أعاده الباك اند من POST /reservations، ويحوي بالأخص:
  /// ticket_id, qr_payload, status, reservation_date, seats_count.
  final Map<String, dynamic> reservation;

  const BookingTicketScreen({
    super.key,
    required this.activity,
    required this.reservation,
  });

  void _goHome(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const HomePageScreen()),
      (route) => false,
    );
  }

  String get _ticketId => reservation['ticket_id']?.toString() ?? '—';

  /// المحتوى الذي يُشفَّر داخل الـQR. هذا هو ما تتحقق منه
  /// TicketScanController::verify عند المسح عبر Crypt::decryptString.
  /// نستخدم qr_payload المشفّر من الباك اند (وليس بيانات خام) حفاظاً على الأمان،
  /// مع وقوع ticket_id كخيار احتياطي فقط في حال عدم توفر qr_payload لأي سبب.
  String get _qrData =>
      reservation['qr_payload']?.toString().trim().isNotEmpty == true
          ? reservation['qr_payload'].toString()
          : _ticketId;

  int get _seatsCount {
    final raw = reservation['seats_count'];
    if (raw is int) return raw;
    return int.tryParse(raw?.toString() ?? '') ?? 1;
  }

  String get _dateLabel {
    final raw = reservation['reservation_date']?.toString();
    final parsed = DateTime.tryParse(raw ?? '') ?? activity.startTime;
    if (parsed == null) return '—';
    return DateFormat('MMM dd, yyyy').format(parsed);
  }

  String get _timeLabel {
    final time = activity.startTime;
    if (time == null) return '—';
    return DateFormat('hh:mm a').format(time);
  }

  bool get _isPremium => (activity.ticketPrice ?? 0) > 0;

  Future<void> _saveTicket(
    BuildContext context,
    ScreenshotController controller,
  ) async {
    try {
      final bytes = await controller.capture(pixelRatio: 3);
      if (bytes == null) return;

      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/ticket_$_ticketId.png');
      await file.writeAsBytes(bytes);

      await Share.shareXFiles(
        [XFile(file.path)],
        text: 'تذكرتي لفعالية ${activity.title}',
      );
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('تعذر حفظ التذكرة: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenshotController = ScreenshotController();

    return Scaffold(
      backgroundColor: ColorManager.lightBackground,
      body: SafeArea(
        child: Column(
          children: [
            // ─── الشريط العلوي ───
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => _goHome(context),
                    icon: Icon(Icons.close, color: ColorManager.black),
                  ),
                  SizedBox(width: 4.w),
                  CustomText(
                    'حالة الحجز',
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    color: ColorManager.black,
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  children: [
                    SizedBox(height: 24.h),

                    // ─── أيقونة النجاح ───
                    Container(
                      width: 84.w,
                      height: 84.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: ColorManager.deepGreen,
                      ),
                      child: Icon(
                        Icons.check,
                        color: ColorManager.titleWhite,
                        size: 42.sp,
                      ),
                    ),
                    SizedBox(height: 18.h),

                    CustomText(
                      'تم تأكيد الحجز!',
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      color: ColorManager.deepGreen,
                    ),
                    SizedBox(height: 8.h),
                    CustomText(
                      'تم تأمين مكانك في ${activity.title}.',
                      fontSize: 13.sp,
                      color: ColorManager.gray,
                      textAlign: TextAlign.center,
                      height: 1.5,
                    ),
                    SizedBox(height: 22.h),

                    // ─── بطاقة التذكرة (تُلتقط كصورة عند الحفظ) ───
                    Screenshot(
                      controller: screenshotController,
                      child: CustomContainer(
                        width: double.infinity,
                        color: ColorManager.titleWhite,
                        radius: 20.r,
                        paddingAll: 18,
                        shadowColor: ColorManager.black.withOpacity(0.06),
                        shadowBlurRadius: 16,
                        shadowOffset: const Offset(0, 6),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                CustomText(
                                  'الفعالية',
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.w600,
                                  color: ColorManager.gray,
                                  letterSpacing: 0.6,
                                ),
                                if (_isPremium)
                                  CustomContainer(
                                    color: const Color(0xFFFCE9C6),
                                    radius: 20.r,
                                    paddingHorizontal: 12,
                                    paddingVertical: 4,
                                    child: CustomText(
                                      'مميزة',
                                      fontSize: 11.sp,
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xFF9A6A00),
                                    ),
                                  ),
                              ],
                            ),
                            SizedBox(height: 4.h),
                            CustomText(
                              activity.title,
                              fontSize: 20.sp,
                              fontWeight: FontWeight.bold,
                              color: ColorManager.deepGreen,
                            ),
                            SizedBox(height: 16.h),
                            const _DashedDivider(),
                            SizedBox(height: 16.h),

                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                _TicketField(label: 'التاريخ', value: _dateLabel),
                                _TicketField(
                                  label: 'الوقت',
                                  value: _timeLabel,
                                  alignEnd: true,
                                ),
                              ],
                            ),
                            SizedBox(height: 16.h),
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                _TicketField(
                                  label: 'رقم الحجز',
                                  value: '#$_ticketId',
                                  valueColor: ColorManager.deepGreen,
                                ),
                                _TicketField(
                                  label: 'المقاعد',
                                  value: '$_seatsCount',
                                  alignEnd: true,
                                ),
                              ],
                            ),
                            SizedBox(height: 20.h),
                            const _DashedDivider(),
                            SizedBox(height: 20.h),

                            // ─── كود الـQR — مولَّد محلياً من qr_payload القادم من الباك اند ───
                            Center(
                              child: Container(
                                padding: EdgeInsets.all(14.w),
                                decoration: BoxDecoration(
                                  color: ColorManager.darkForestGreen,
                                  borderRadius: BorderRadius.circular(16.r),
                                ),
                                child: Container(
                                  padding: EdgeInsets.all(10.w),
                                  decoration: BoxDecoration(
                                    color: ColorManager.titleWhite,
                                    borderRadius:
                                        BorderRadius.circular(10.r),
                                  ),
                                  child: QrImageView(
                                    data: _qrData,
                                    version: QrVersions.auto,
                                    size: 170.w,
                                    backgroundColor: ColorManager.titleWhite,
                                    eyeStyle: QrEyeStyle(
                                      eyeShape: QrEyeShape.square,
                                      color: ColorManager.darkForestGreen,
                                    ),
                                    dataModuleStyle: QrDataModuleStyle(
                                      dataModuleShape:
                                          QrDataModuleShape.square,
                                      color: ColorManager.darkForestGreen,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 14.h),
                            CustomText(
                              'اعرض هذا الرمز عند مدخل ${activity.locationLabel}.',
                              fontSize: 12.sp,
                              color: ColorManager.gray,
                              textAlign: TextAlign.center,
                              height: 1.5,
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 26.h),
                  ],
                ),
              ),
            ),

            // ─── زر حفظ/مشاركة التذكرة ───
            Padding(
              padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 20.h),
              child: SizedBox(
                width: double.infinity,
                child: CustomElevatedButton(
                  onPressed: () {
                    _saveTicket(context, screenshotController);
                    _showSuccessBottomSheet(context);
                  },
                  backgroundColor: ColorManager.darkForestGreen,
                  radius: 30.r,
                  fixedSize: Size(double.infinity, 56.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.download_outlined,
                        color: ColorManager.titleWhite,
                        size: 20.sp,
                      ),
                      SizedBox(width: 8.w),
                      CustomText(
                        'حفظ التذكرة',
                        color: ColorManager.titleWhite,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TicketField extends StatelessWidget {
  final String label;
  final String value;
  final bool alignEnd;
  final Color? valueColor;

  const _TicketField({
    required this.label,
    required this.value,
    this.alignEnd = false,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          alignEnd ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        CustomText(
          label,
          fontSize: 11.sp,
          color: ColorManager.gray,
        ),
        SizedBox(height: 4.h),
        CustomText(
          value,
          fontSize: 14.sp,
          fontWeight: FontWeight.w600,
          color: valueColor ?? ColorManager.black,
        ),
      ],
    );
  }
}

class _DashedDivider extends StatelessWidget {
  const _DashedDivider();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const dashWidth = 6.0;
        const dashSpace = 4.0;
        final dashCount =
            (constraints.constrainWidth() / (dashWidth + dashSpace)).floor();
        return Row(
          children: List.generate(dashCount, (_) {
            return Padding(
              padding: const EdgeInsets.only(right: dashSpace),
              child: Container(
                width: dashWidth,
                height: 1.h,
                color: ColorManager.lightGray,
              ),
            );
          }),
        );
      },
    );
  }
}
void _showSuccessBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true, // للسماح بالتحكم بالحجم
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    backgroundColor: Colors.white,
    builder: (BuildContext context) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0.w, vertical: 20.0.h),
        child: Column(
          mainAxisSize: MainAxisSize.min, // لجعل الارتفاع على قدر المحتوى
          children: [
            // الخط الرمادي الصغير في الأعلى (مقبض السحب)
            Container(
              width: 50.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
            SizedBox(height: 30.h),
            
            // أيقونة النجاح (استبدل المسار بمسار الصورة لديك في assets)
            // إذا لم تكن الصورة متوفرة كـ asset يمكنك مؤقتاً استخدام Icon
            Image.asset(
              AssetsManager.saveTicket, // مسار صورة الصح الأخضر
              height: 80.h,
              width: 80.w,
              fit: BoxFit.cover,
            ),
            /* كبديل باستخدام الأيقونات في حال لم توجد الصورة:
            Icon(Icons.check_circle, color: Color(0xFF1E5631), size: 80.sp),
            */
            SizedBox(height: 24.h),
            
            // العنوان
            Text(
              'تم حفظ التذكرة بنجاح',
              style: TextStyle(
                fontSize: 22.sp,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E5631), // درجة اللون الأخضر الغامق المطابقة للصورة
                fontFamily: 'Cairo', // استخدم الخط المناسب لتطبيقك
              ),
            ),
            SizedBox(height: 12.h),
            
            // النص الفرعي
            Text(
              'يمكنك الآن العثور على تذكرتك في قسم\nالتذاكر الخاص بملفك الشخصي.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.grey,
                height: 1.5,
                fontFamily: 'Cairo',
              ),
            ),
            SizedBox(height: 32.h),
            
            // زر "تم"
            SizedBox(
              width: double.infinity,
              height: 50.h,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E5631), // لون الزر الأخضر
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  elevation: 0,
                ),
                onPressed: () {
                  // الانتقال إلى الواجهة الرئيسية وحذف كل الصفحات السابقة من الذاكرة
                  // استبدل HomePageScreen() باسم كلاس الواجهة الرئيسية لديك
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HomePageScreen(), 
                    ),
                    (route) => false, // false تعني حذف جميع الواجهات السابقة
                  );
                },
                child: Text(
                  'تم',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: 'Cairo',
                  ),
                ),
              ),
            ),
            SizedBox(height: 10.h),
          ],
        ),
      );
    },
  );
}