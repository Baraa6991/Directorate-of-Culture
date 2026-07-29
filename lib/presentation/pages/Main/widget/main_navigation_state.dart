class MainNavigationState {
  final int selectedIndex;

  const MainNavigationState({this.selectedIndex = 0});

  MainNavigationState copyWith({int? selectedIndex}) {
    return MainNavigationState(
      selectedIndex: selectedIndex ?? this.selectedIndex,
    );
  }
}
