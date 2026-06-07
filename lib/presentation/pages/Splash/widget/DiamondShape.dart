import 'dart:math' as math;

import 'package:directorateofculture/presentation/util/custom_container.dart';
import 'package:flutter/material.dart';

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
          width: 25,
          height: 25,
          child: CustomContainer(color: color, borderWidth: 1.5, radius: 2),
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
      width: 130,
      height: 130,
      child: Stack(
        children: [
          Diamondshape(top: 10, left: 50, color: color),
          Diamondshape(top: 45, left: 10, color: color),
          Diamondshape(top: 45, left: 90, color: color),
          Diamondshape(top: 80, left: 50, color: color),
        ],
      ),
    );
  }
}
