import 'package:directorateofculture/presentation/pages/Events/Model/event_model.dart';

abstract class EventDetailsState {
  const EventDetailsState();
}

class EventDetailsLoading extends EventDetailsState {
  const EventDetailsLoading();
}

class EventDetailsLoaded extends EventDetailsState {
  final ActivityCardModel activity;
  const EventDetailsLoaded(this.activity);
}

class EventDetailsError extends EventDetailsState {
  final String message;
  const EventDetailsError(this.message);
}