import 'archive_center_model.dart';
import 'archive_event_model.dart';

class ArchiveState {
  final int selectedTabIndex; // 0 = events, 1 = centers
  final List<ArchiveEventModel> events;
  final List<ArchiveCenterModel> centers;

  const ArchiveState({
    this.selectedTabIndex = 0,
    this.events = const [],
    this.centers = const [],
  });

  ArchiveState copyWith({
    int? selectedTabIndex,
    List<ArchiveEventModel>? events,
    List<ArchiveCenterModel>? centers,
  }) {
    return ArchiveState(
      selectedTabIndex: selectedTabIndex ?? this.selectedTabIndex,
      events: events ?? this.events,
      centers: centers ?? this.centers,
    );
  }
}
