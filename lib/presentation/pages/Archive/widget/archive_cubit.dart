import 'package:directorateofculture/Constant/assets_manager.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'archive_center_model.dart';
import 'archive_event_model.dart';
import 'archive_state.dart';

class ArchiveCubit extends Cubit<ArchiveState> {
  ArchiveCubit()
    : super(
        ArchiveState(
          events: [
            ArchiveEventModel(
              id: 'calligraphy-masterclass',
              title: 'ورشة الخط العربي الحديث',
              description:
                  'انضم إلى الخطاط أحمد في استكشاف تطور النصوص العربية في '
                  'التصميم المعاصر.',
              categoryBadge: 'ورشة عمل',
              imageAsset: AssetsManager.onboarding1Discover,
              date: '24 أكتوبر 2023',
              time: '05:00 م',
              reservationCode: '#EV-29401',
              location: 'المركز الوطني للفنون',
              status: ArchiveReservationStatus.confirmedPaid,
              actionLabel: 'عرض رمز QR',
            ),
            ArchiveEventModel(
              id: 'sustainable-heritage-lecture',
              title: 'عمارة التراث المستدام',
              description:
                  'نظرة عميقة في تقنيات الحفاظ التاريخي في العصر الرقمي.',
              categoryBadge: 'ندوة',
              imageAsset: AssetsManager.onboarding2Discover,
              date: '02 نوفمبر 2023',
              location: 'ساحة الثقافة',
              status: ArchiveReservationStatus.underReview,
              actionLabel: 'عرض التفاصيل',
            ),
            const ArchiveEventModel(
              id: 'garden-symphony',
              title: 'سيمفونية في الحديقة',
              categoryBadge: 'حفل مباشر',
              status: ArchiveReservationStatus.rejected,
              rejectionReason:
                  'وصلت الفعالية إلى الحد الأقصى للسعة لفئة المقاعد المختارة.',
              actionLabel: 'تواصل مع المنظم',
            ),
            ArchiveEventModel(
              id: 'craft-heritage-trail',
              title: 'مسار التراث الحرفي',
              categoryBadge: 'جولة فنية',
              imageAsset: AssetsManager.onboarding3Discover,
              date: '15 نوفمبر 2023',
              time: '10:00 ص',
              status: ArchiveReservationStatus.underReview,
              actionLabel: 'عرض التفاصيل',
            ),
            ArchiveEventModel(
              id: 'old-spice-route',
              title: 'تاريخ التوابل القديمة',
              categoryBadge: 'جولة',
              imageAsset: AssetsManager.onboarding1Discover,
              date: '10 أكتوبر 2023',
              location: 'المتحف الوطني',
              status: ArchiveReservationStatus.completed,
              actionLabel: 'عرض النقاط',
            ),
          ],
          centers: const [
            ArchiveCenterModel(
              id: 'king-abdulaziz-center',
              title: 'مركز الملك عبدالعزيز الثقافي',
              reservationCode: '#RES-9021',
              date: '14 أكتوبر 2023 - 04:30 م',
              status: ArchiveReservationStatus.awaitingPayment,
              actionLabel: 'إكمال الدفع',
            ),
            ArchiveCenterModel(
              id: 'contemporary-art-museum',
              title: 'متحف الفن المعاصر',
              reservationCode: '#RES-8842',
              date: '20 أكتوبر 2023 - 09:00 ص',
              status: ArchiveReservationStatus.confirmedPaid,
              actionLabel: 'عرض التفاصيل',
              showShareIcon: true,
            ),
            ArchiveCenterModel(
              id: 'arabic-calligraphy-workshop',
              title: 'ورشة الخط العربي',
              reservationCode: '#RES-7210',
              date: '25 أكتوبر 2023 - 06:00 م',
              status: ArchiveReservationStatus.underReview,
              actionLabel: 'تواصل مع المركز',
            ),
            ArchiveCenterModel(
              id: 'national-heritage-exhibit',
              title: 'معرض التراث الوطني',
              reservationCode: '#RES-6544',
              date: '05 نوفمبر 2023 - 07:00 م',
              status: ArchiveReservationStatus.rejected,
              rejectionReason: 'عذرا، الجلسة المطلوبة وصلت للحد الأقصى.',
              actionLabel: 'إعادة الحجز',
            ),
            ArchiveCenterModel(
              id: 'literary-thought-seminar',
              title: 'ندوة الفكر الأدبي',
              reservationCode: '#RES-5021',
              date: '01 أكتوبر 2023 - 08:30 م',
              status: ArchiveReservationStatus.completed,
              actionLabel: '',
            ),
          ],
        ),
      );

  void selectTab(int index) {
    emit(state.copyWith(selectedTabIndex: index));
  }
}
