import 'package:directorateofculture/Constant/color_manager.dart';
import 'package:directorateofculture/presentation/pages/Events/widget/event_model.dart';
import 'package:directorateofculture/presentation/pages/Events/widget/events_cubit.dart';
import 'package:directorateofculture/presentation/pages/Events/widget/events_state.dart';
import 'package:directorateofculture/presentation/pages/Events/widget/review_card.dart';
import 'package:directorateofculture/presentation/pages/Events/widget/speaker_card.dart';
import 'package:directorateofculture/presentation/util/custom_container.dart';
import 'package:directorateofculture/presentation/util/custom_elevatedButton.dart';
import 'package:directorateofculture/presentation/util/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'book_event_screen.dart';

class EventDetailsScreen extends StatelessWidget {
  final String eventId;

  const EventDetailsScreen({super.key, required this.eventId});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: ColorManager.titleWhite,
        body: BlocBuilder<EventsCubit, EventsState>(
          builder: (context, state) {
            final event = state.events.firstWhere((e) => e.id == eventId);
            final cubit = context.read<EventsCubit>();

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _Hero(
                    event: event,
                    onToggleFavorite: () => cubit.toggleFavorite(event.id),
                  ),
                  Transform.translate(
                    offset: const Offset(0, -24),
                    child: CustomContainer(
                      width: double.infinity,
                      color: ColorManager.titleWhite,
                      radius: 24,
                      paddingAll: 20,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            event.title,
                            color: ColorManager.deepGreen,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                          const SizedBox(height: 14),
                          _InfoRow(
                            icon: Icons.calendar_today,
                            title: '${event.date}, ${event.time}',
                            subtitle: event.sessionLabel,
                          ),
                          const SizedBox(height: 10),
                          _InfoRow(
                            icon: Icons.location_on_outlined,
                            title: event.location,
                            subtitle: event.locationDetail,
                          ),
                          if (event.description.isNotEmpty) ...[
                            const SizedBox(height: 22),
                            CustomText(
                              'عن الفعالية',
                              color: ColorManager.darkForestGreen,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                            const SizedBox(height: 10),
                            _ExpandableDescription(text: event.description),
                          ],
                          if (event.speakers.isNotEmpty) ...[
                            const SizedBox(height: 22),
                            CustomText(
                              'المتحدثون',
                              color: ColorManager.darkForestGreen,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                            const SizedBox(height: 10),
                            SizedBox(
                              height: 66,
                              child: ListView.separated(
                                scrollDirection: Axis.horizontal,
                                itemCount: event.speakers.length,
                                separatorBuilder: (_, __) =>
                                    const SizedBox(width: 10),
                                itemBuilder: (context, index) =>
                                    SpeakerCard(speaker: event.speakers[index]),
                              ),
                            ),
                          ],
                          if (event.pastWorkshopImages.isNotEmpty) ...[
                            const SizedBox(height: 22),
                            CustomText(
                              'ورش سابقة',
                              color: ColorManager.darkForestGreen,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                            const SizedBox(height: 10),
                            SizedBox(
                              height: 90,
                              child: ListView.separated(
                                scrollDirection: Axis.horizontal,
                                itemCount: event.pastWorkshopImages.length,
                                separatorBuilder: (_, __) =>
                                    const SizedBox(width: 10),
                                itemBuilder: (context, index) => ClipRRect(
                                  borderRadius: BorderRadius.circular(14),
                                  child: Image.asset(
                                    event.pastWorkshopImages[index],
                                    width: 130,
                                    height: 90,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                          ],
                          if (event.reviews.isNotEmpty) ...[
                            const SizedBox(height: 22),
                            Row(
                              children: [
                                CustomText(
                                  'التقييمات',
                                  color: ColorManager.darkForestGreen,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                                const Spacer(),
                                Icon(
                                  Icons.star,
                                  size: 16,
                                  color: ColorManager.starRating,
                                ),
                                const SizedBox(width: 4),
                                CustomText(
                                  '${event.rating} (${event.reviewCount})',
                                  color: ColorManager.black,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            for (final review in event.reviews)
                              ReviewCard(review: review),
                          ],
                          const SizedBox(height: 90),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        bottomNavigationBar: BlocBuilder<EventsCubit, EventsState>(
          builder: (context, state) {
            final event = state.events.firstWhere((e) => e.id == eventId);
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                child: Row(
                  children: [
                    CustomText(
                      event.isFreeEntry ? 'دخول مجاني' : 'دخول مدفوع',
                      color: ColorManager.liveBadge,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                    const Spacer(),
                    CustomElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => BookEventScreen(event: event),
                          ),
                        );
                      },
                      backgroundColor: ColorManager.deepGreen,
                      foregroundColor: ColorManager.titleWhite,
                      radius: 26,
                      paddingHorizontal: 26,
                      paddingVertical: 14,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CustomText(
                            'احجز الآن',
                            color: ColorManager.titleWhite,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                          const SizedBox(width: 8),
                          const Icon(
                            Icons.arrow_forward,
                            color: ColorManager.titleWhite,
                            size: 16,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _Hero extends StatelessWidget {
  final EventModel event;
  final VoidCallback onToggleFavorite;

  const _Hero({required this.event, required this.onToggleFavorite});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 320,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(event.imageAsset, fit: BoxFit.cover),
          Positioned(
            top: 50,
            left: 16,
            right: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CircleAvatar(
                  backgroundColor: ColorManager.titleWhite,
                  child: IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(
                      Icons.arrow_back,
                      color: ColorManager.black,
                    ),
                  ),
                ),
                CircleAvatar(
                  backgroundColor: ColorManager.titleWhite,
                  child: IconButton(
                    onPressed: onToggleFavorite,
                    icon: Icon(
                      event.isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: event.isFavorite
                          ? ColorManager.deepGreen
                          : ColorManager.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: 16,
            bottom: 40,
            child: Row(
              children: [
                if (event.isLive)
                  Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: ColorManager.liveBadge,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: CustomText(
                      'مباشر الآن',
                      color: ColorManager.titleWhite,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: ColorManager.lightGreen,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: CustomText(
                    eventCategoryLabels[event.category] ?? event.category,
                    color: ColorManager.darkForestGreen,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _InfoRow({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 34,
          height: 34,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: ColorManager.lightGreen.withOpacity(0.3),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 16, color: ColorManager.darkForestGreen),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              title,
              color: ColorManager.black,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
            if (subtitle.isNotEmpty)
              CustomText(subtitle, color: ColorManager.gray, fontSize: 12),
          ],
        ),
      ],
    );
  }
}

/// Trivial, non-reusable UI-only toggle (expand/collapse a paragraph) — kept
/// as a small local StatefulWidget rather than a Cubit, per the project's own
/// guidance that only genuinely reusable/complex state should go through
/// flutter_bloc.
class _ExpandableDescription extends StatefulWidget {
  final String text;

  const _ExpandableDescription({required this.text});

  @override
  State<_ExpandableDescription> createState() => _ExpandableDescriptionState();
}

class _ExpandableDescriptionState extends State<_ExpandableDescription> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          widget.text,
          color: ColorManager.gray,
          fontSize: 13,
          maxLines: _expanded ? null : 3,
          overflow: _expanded ? null : TextOverflow.ellipsis,
        ),
        const SizedBox(height: 6),
        GestureDetector(
          onTap: () => setState(() => _expanded = !_expanded),
          child: CustomText(
            _expanded ? 'عرض أقل' : 'قراءة المزيد',
            color: ColorManager.deepGreen,
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
