import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CarouselCubit extends Cubit<int> {
  CarouselCubit(this.images) : super(0) {
    Timer.periodic(const Duration(seconds: 3), (_) {
      final next = (state + 1) % images.length;
      controller.animateToPage(
        next,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
      emit(next);
    });
  }

  final List<String> images;
  final PageController controller = PageController();
}