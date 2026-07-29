import 'event_model.dart';

class EventsState {
  final List<EventModel> events;
  final String query;
  final String
  selectedCategory; // 'All' / 'Workshop' / 'Lecture' / 'Exhibition' (singular, matches EventModel.category; chip labels are pluralized for display only)

  const EventsState({
    this.events = const [],
    this.query = '',
    this.selectedCategory = 'All',
  });

  List<EventModel> get filteredEvents {
    return events.where((event) {
      final matchesCategory =
          selectedCategory == 'All' || event.category == selectedCategory;
      final matchesQuery =
          query.trim().isEmpty ||
          event.title.toLowerCase().contains(query.trim().toLowerCase());
      return matchesCategory && matchesQuery;
    }).toList();
  }

  EventModel? get liveEvent {
    for (final event in events) {
      if (event.isLive) return event;
    }
    return null;
  }

  EventsState copyWith({
    List<EventModel>? events,
    String? query,
    String? selectedCategory,
  }) {
    return EventsState(
      events: events ?? this.events,
      query: query ?? this.query,
      selectedCategory: selectedCategory ?? this.selectedCategory,
    );
  }
}
