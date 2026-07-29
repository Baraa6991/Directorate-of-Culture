import 'package:flutter_bloc/flutter_bloc.dart';

import 'main_navigation_state.dart';

class MainNavigationCubit extends Cubit<MainNavigationState> {
  MainNavigationCubit() : super(const MainNavigationState());

  void selectTab(int index) {
    emit(state.copyWith(selectedIndex: index));
  }
}
