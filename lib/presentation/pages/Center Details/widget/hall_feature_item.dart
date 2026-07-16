import 'package:directorateofculture/presentation/pages/Center%20Details/widget/FacilityModel.dart';
import 'package:directorateofculture/presentation/pages/Center%20Details/widget/facility_icon_mapper.dart';
import 'package:directorateofculture/Constant/color_manager.dart';
import 'package:directorateofculture/presentation/util/custom_text.dart';
import 'package:flutter/material.dart';

class HallFeatureItem extends StatelessWidget {
  final FacilityModel feature;

  const HallFeatureItem({super.key, required this.feature});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 34,
          height: 34,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: ColorManager.lightGreen.withOpacity(0.3),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            FacilityIconMapper.resolve(feature.iconKey),
            size: 16,
            color: ColorManager.darkForestGreen,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: CustomText(
            feature.label,
            fontSize: 13,
            color: ColorManager.black,
          ),
        ),
      ],
    );
  }
}
