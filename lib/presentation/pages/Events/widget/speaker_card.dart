import 'package:directorateofculture/Constant/color_manager.dart';
import 'package:directorateofculture/presentation/util/custom_text.dart';
import 'package:flutter/material.dart';

import 'event_model.dart';

class SpeakerCard extends StatelessWidget {
  final SpeakerInfo speaker;

  const SpeakerCard({super.key, required this.speaker});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: ColorManager.titleWhite,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: ColorManager.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundImage: AssetImage(speaker.avatarAsset),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  speaker.name,
                  color: ColorManager.black,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
                const SizedBox(height: 2),
                CustomText(
                  speaker.title,
                  color: ColorManager.gray,
                  fontSize: 11,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
