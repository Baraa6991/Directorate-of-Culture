import 'package:bloc/bloc.dart';
import 'package:directorateofculture/presentation/pages/Events/Cubit/event_details_state.dart';
import 'package:directorateofculture/repositories/home_repository.dart';
import 'package:flutter/foundation.dart';

class EventDetailsCubit extends Cubit<EventDetailsState> {
  final HomeRepository repository;
  final int activityId;

  EventDetailsCubit({
    required this.repository,
    required this.activityId,
  }) : super(const EventDetailsLoading());

  Future<void> loadActivity() async {
    emit(const EventDetailsLoading());
    try {
      // ✅ جلب الفعالية مباشرة بالـ id بدل تحميل كل القائمة والبحث محلياً
      final activity = await repository.getActivityById(activityId);
      emit(EventDetailsLoaded(activity));
    } catch (e) {
      debugPrint('💥 Event details load error: $e');
      emit(EventDetailsError(e.toString().replaceAll('Exception: ', '')));
    }
  }
}