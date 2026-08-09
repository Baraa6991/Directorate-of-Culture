import 'dart:math' as math;

import 'package:directorateofculture/presentation/util/custom_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class Diamondshape extends StatelessWidget {
  final double top;
  final double left;
  final Color? color;
  const Diamondshape({
    super.key,
    required this.top,
    required this.left,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      left: left,
      child: Transform.rotate(
        angle: math.pi / 4,
        child: SizedBox(
          width: 25.w,
          height: 25.h,
          child: CustomContainer(color: color, borderWidth: 1.5, radius: 2.r),
        ),
      ),
    );
  }
}

class DiamondPattern extends StatelessWidget {
  final Color color;

  const DiamondPattern({super.key, required this.color});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120.w,
      height: 130.h,
      child: Stack(
        children: [
          Diamondshape(top: 10.h, left: 50.w, color: color),
          Diamondshape(top: 45.h, left: 10.w, color: color),
          Diamondshape(top: 45.h, left: 90.w, color: color),
          Diamondshape(top: 80.h, left: 50.w, color: color),
        ],
      ),
    );
  }
}
