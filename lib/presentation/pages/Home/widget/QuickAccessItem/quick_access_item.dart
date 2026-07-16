import 'package:directorateofculture/Constant/color_manager.dart';
import 'package:directorateofculture/presentation/util/custom_text.dart';
import 'package:flutter/material.dart';

class QuickAccessItem {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  const QuickAccessItem({
    required this.icon,
    required this.label,
    this.onTap,
  });
}

class QuickAccessGrid extends StatelessWidget {
  final List<QuickAccessItem>? items;

  const QuickAccessGrid({super.key, this.items});

  List<QuickAccessItem> get _defaultItems => [
        QuickAccessItem(
          icon: Icons.account_balance_outlined,
          label: 'المراكز',
          onTap: () {},
        ),
        QuickAccessItem(
          icon: Icons.event_outlined,
          label: 'الفعاليات',
          onTap: () {},
        ),
        QuickAccessItem(
          icon: Icons.bookmark_outline,
          label: 'المكتبة',
          onTap: () {},
        ),
        QuickAccessItem(
          icon: Icons.map_outlined,
          label: 'الخريطة',
          onTap: () {},
        ),
      ];

  @override
  Widget build(BuildContext context) {
    final data = items ?? _defaultItems;

    return Column(
      children: [
        for (int row = 0; row < data.length; row += 2) ...[
          Row(
            children: [
              Expanded(child: _QuickAccessCard(item: data[row])),
              const SizedBox(width: 14),
              if (row + 1 < data.length)
                Expanded(child: _QuickAccessCard(item: data[row + 1]))
              else
                const Expanded(child: SizedBox()),
            ],
          ),
          if (row + 2 < data.length) const SizedBox(height: 14),
        ],
      ],
    );
  }
}

class _QuickAccessCard extends StatelessWidget {
  final QuickAccessItem item;

  const _QuickAccessCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: item.onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 22),
        decoration: BoxDecoration(
          color: ColorManager.titleWhite,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                color: ColorManager.lightBackground,
                shape: BoxShape.circle,
              ),
              child: Icon(
                item.icon,
                color: ColorManager.deepGreen,
                size: 26,
              ),
            ),
            const SizedBox(height: 10),
            CustomText(
              item.label,
              color: ColorManager.deepGreen,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ],
        ),
      ),
    );
  }
}