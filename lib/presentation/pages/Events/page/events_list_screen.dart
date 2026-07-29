import 'package:directorateofculture/Constant/color_manager.dart';
import 'package:directorateofculture/presentation/pages/Events/widget/category_filter_chip.dart';
import 'package:directorateofculture/presentation/pages/Events/widget/event_card.dart';
import 'package:directorateofculture/presentation/pages/Events/widget/event_model.dart';
import 'package:directorateofculture/presentation/pages/Events/widget/events_cubit.dart';
import 'package:directorateofculture/presentation/pages/Events/widget/events_state.dart';
import 'package:directorateofculture/presentation/pages/Events/widget/live_event_banner.dart';
import 'package:directorateofculture/presentation/util/custom_text.dart';
import 'package:directorateofculture/presentation/util/custom_textField.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'event_details_screen.dart';

/// Events tab body. No own Scaffold/bottom bar — it's rendered inside
/// MainShell's IndexedStack, which owns the shared Scaffold + bottom nav.
class EventsListScreen extends StatelessWidget {
  const EventsListScreen({super.key});

  static const _categories = ['All', 'Workshop', 'Lecture', 'Exhibition'];

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: BlocProvider(
        create: (_) => EventsCubit(),
        child: Builder(
          builder: (context) {
            final cubit = context.read<EventsCubit>();
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: BlocBuilder<EventsCubit, EventsState>(
                  builder: (context, state) {
                    final liveEvent = state.liveEvent;
                    final upcoming = state.filteredEvents
                        .where((event) => !event.isLive)
                        .toList();

                    return CustomScrollView(
                      slivers: [
                        const SliverToBoxAdapter(child: SizedBox(height: 16)),
                        SliverToBoxAdapter(
                          child: CustomText(
                            'الفعاليات',
                            color: ColorManager.deepGreen,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SliverToBoxAdapter(child: SizedBox(height: 16)),
                        SliverToBoxAdapter(
                          child: CustomTextfield(
                            hint: 'ابحث عن الفعاليات',
                            hintColor: ColorManager.lightGray,
                            prefixIcon: Icon(
                              Icons.search,
                              color: ColorManager.gray,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide.none,
                            ),
                            focusColor: ColorManager.deepGreen,
                            onChanged: cubit.search,
                          ),
                        ),
                        const SliverToBoxAdapter(child: SizedBox(height: 14)),
                        SliverToBoxAdapter(
                          child: SizedBox(
                            height: 40,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: _categories.length,
                              separatorBuilder: (_, __) =>
                                  const SizedBox(width: 10),
                              itemBuilder: (context, index) {
                                final category = _categories[index];
                                return CategoryFilterChip(
                                  label: eventCategoryFilterLabels[category]!,
                                  selected: state.selectedCategory == category,
                                  onTap: () => cubit.selectCategory(category),
                                );
                              },
                            ),
                          ),
                        ),
                        const SliverToBoxAdapter(child: SizedBox(height: 20)),
                        if (liveEvent != null)
                          SliverToBoxAdapter(
                            child: LiveEventBanner(
                              event: liveEvent,
                              onTap: () =>
                                  _openDetails(context, cubit, liveEvent),
                            ),
                          ),
                        const SliverToBoxAdapter(child: SizedBox(height: 24)),
                        SliverToBoxAdapter(
                          child: CustomText(
                            'فعاليات قادمة لك',
                            color: ColorManager.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SliverToBoxAdapter(child: SizedBox(height: 12)),
                        SliverToBoxAdapter(
                          child: Column(
                            children: [
                              for (final event in upcoming) ...[
                                EventCard(
                                  event: event,
                                  onTap: () =>
                                      _openDetails(context, cubit, event),
                                  // "Book" opens Event Details rather than the
                                  // booking flow directly.
                                  onBook: () =>
                                      _openDetails(context, cubit, event),
                                  onToggleFavorite: () =>
                                      cubit.toggleFavorite(event.id),
                                ),
                                const SizedBox(height: 14),
                              ],
                            ],
                          ),
                        ),
                        const SliverToBoxAdapter(child: SizedBox(height: 20)),
                      ],
                    );
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _openDetails(BuildContext context, EventsCubit cubit, EventModel event) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: cubit,
          child: EventDetailsScreen(eventId: event.id),
        ),
      ),
    );
  }
}
