import 'package:directorateofculture/Constant/color_manager.dart';
import 'package:directorateofculture/presentation/util/custom_elevatedButton.dart';
import 'package:directorateofculture/presentation/util/custom_text.dart';
import 'package:flutter/material.dart';

import 'event_model.dart';

/// "Upcoming for You" list card on the Events list screen.
class EventCard extends StatelessWidget {
  final EventModel event;
  final VoidCallback? onTap;
  final VoidCallback? onBook;
  final VoidCallback? onToggleFavorite;

  const EventCard({
    super.key,
    required this.event,
    this.onTap,
    this.onBook,
    this.onToggleFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: ColorManager.titleWhite,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: ColorManager.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Image.asset(
                event.imageAsset,
                height: 80,
                width: 80,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: CustomText(
                          event.title,
                          color: ColorManager.black,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      GestureDetector(
                        onTap: onToggleFavorite,
                        child: Icon(
                          event.isFavorite
                              ? Icons.favorite
                              : Icons.favorite_border,
                          size: 20,
                          color: event.isFavorite
                              ? ColorManager.deepGreen
                              : ColorManager.black,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: 13,
                        color: ColorManager.black,
                      ),
                      const SizedBox(width: 5),
                      CustomText(
                        '${event.date} • ${event.time}',
                        color: ColorManager.black,
                        fontSize: 12,
                      ),
                    ],
                  ),
                  if (event.seatsAvailable != null) ...[
                    const SizedBox(height: 4),
                    CustomText(
                      '${event.seatsAvailable} مقعد متاح',
                      color: ColorManager.accentGreen,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ],
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        size: 14,
                        color: ColorManager.black,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: CustomText(
                          event.location,
                          color: ColorManager.black,
                          fontSize: 12,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      CustomElevatedButton(
                        onPressed: onBook,
                        backgroundColor: ColorManager.deepGreen,
                        foregroundColor: ColorManager.titleWhite,
                        radius: 20,
                        paddingHorizontal: 18,
                        paddingVertical: 8,
                        child: CustomText(
                          'حجز',
                          color: ColorManager.titleWhite,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
