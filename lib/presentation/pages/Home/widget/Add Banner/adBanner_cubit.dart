import 'dart:async';

import 'package:directorateofculture/presentation/pages/Home/widget/Add%20Banner/adBannerItem.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdBannerCubit extends Cubit<AdBannerState> {
  Timer? _timer;

  AdBannerCubit(List<AdBannerItem> ads)
      : super(AdBannerState(ads: ads)) {
    _startAutoScroll();
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(const Duration(seconds: 6), (timer) {
      goToNext();
    });
  }

  void goToNext() {
    if (state.ads.isEmpty) return;
    final nextIndex = (state.currentIndex + 1) % state.ads.length;
    emit(state.copyWith(currentIndex: nextIndex));
  }

  void goToPage(int index) {
    emit(state.copyWith(currentIndex: index));
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}