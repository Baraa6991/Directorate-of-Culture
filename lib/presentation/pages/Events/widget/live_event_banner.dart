import 'package:directorateofculture/Constant/color_manager.dart';
import 'package:directorateofculture/presentation/util/custom_text.dart';
import 'package:flutter/material.dart';

import 'event_model.dart';

/// Hero "LIVE NOW" card at the top of the Events list.
class LiveEventBanner extends StatelessWidget {
  final EventModel event;
  final VoidCallback? onTap;

  const LiveEventBanner({super.key, required this.event, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: SizedBox(
          height: 220,
          width: double.infinity,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(event.imageAsset, fit: BoxFit.cover),
              DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      ColorManager.black.withOpacity(0.75),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 14,
                left: 14,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: ColorManager.liveBadge,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                          color: ColorManager.titleWhite,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      CustomText(
                        'مباشر الآن',
                        color: ColorManager.titleWhite,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 16,
                right: 16,
                bottom: 16,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      event.title,
                      color: ColorManager.titleWhite,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          size: 13,
                          color: ColorManager.titleWhite,
                        ),
                        const SizedBox(width: 6),
                        CustomText(
                          '${event.date} • ${event.time}',
                          color: ColorManager.titleWhite,
                          fontSize: 13,
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: 13,
                          color: ColorManager.titleWhite,
                        ),
                        const SizedBox(width: 6),
                        CustomText(
                          event.location,
                          color: ColorManager.titleWhite,
                          fontSize: 13,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
