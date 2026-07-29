import 'package:directorateofculture/Constant/assets_manager.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'event_model.dart';
import 'events_state.dart';

class EventsCubit extends Cubit<EventsState> {
  EventsCubit()
    : super(
        EventsState(
          events: [
            EventModel(
              id: 'calligraphy-masterclass',
              title: 'ورشة الخط العربي المتقدمة',
              category: 'Workshop',
              isLive: true,
              date: '24 أكتوبر',
              time: '10:00 صباحًا',
              sessionLabel: 'جلسة صباح الخميس',
              location: 'القاعة الرئيسية أ',
              locationDetail: 'الجناح الشرقي - المركز الثقافي',
              seatsAvailable: 20,
              imageAsset: AssetsManager.onboarding1Discover,
              description:
                  'اكتشف فن الخط العربي القديم بأسلوبي الثلث والنسخ في هذه الورشة '
                  'المكثفة. الخط العربي أكثر من مجرد كتابة؛ إنه رقصة روحية من '
                  'الهندسة والإيقاع شكّلت الهوية الثقافية عبر القرون. بإشراف خبراء '
                  'متخصصين، ستتعرف على تشريح الحروف وفن التأمل في القلم...',
              isFreeEntry: true,
              speakers: [
                SpeakerInfo(
                  name: 'د. سلمى راشد',
                  title: 'خطاطة محترفة',
                  avatarAsset: AssetsManager.logo,
                ),
              ],
              pastWorkshopImages: [AssetsManager.onboarding2Discover],
              rating: 4.9,
              reviewCount: 124,
              reviews: [
                ReviewInfo(
                  reviewerName: 'سارة م.',
                  avatarAsset: AssetsManager.logo,
                  rating: 5,
                  comment:
                      'تجربة رائعة! كان المدربون صبورين والأجواء هادئة جدًا. '
                      'أنصح بها بشدة للمبتدئين.',
                ),
                ReviewInfo(
                  reviewerName: 'عمر ك.',
                  avatarAsset: AssetsManager.logo,
                  rating: 4,
                  comment:
                      'مزيج مثالي بين الثقافة والفن. كانت القاعة منظمة جيدًا '
                      'والمواد المقدمة عالية الجودة.',
                ),
              ],
            ),
            EventModel(
              id: 'pottery-workshop',
              title: 'ورشة صناعة الفخار',
              category: 'Workshop',
              date: '26 أكتوبر',
              time: '04:00 مساءً',
              location: 'الاستوديو 2',
              seatsAvailable: 20,
              imageAsset: AssetsManager.onboarding3Discover,
            ),
            EventModel(
              id: 'history-lecture',
              title: 'محاضرة في التاريخ',
              category: 'Lecture',
              date: '28 أكتوبر',
              time: '06:30 مساءً',
              location: 'جناح المكتبة',
              seatsAvailable: 15,
              imageAsset: AssetsManager.onboarding1Discover,
            ),
          ],
        ),
      );

  void search(String query) {
    emit(state.copyWith(query: query));
  }

  void selectCategory(String category) {
    emit(state.copyWith(selectedCategory: category));
  }

  void toggleFavorite(String eventId) {
    final updated = state.events.map((event) {
      if (event.id != eventId) return event;
      return event.copyWith(isFavorite: !event.isFavorite);
    }).toList();
    emit(state.copyWith(events: updated));
  }
}
