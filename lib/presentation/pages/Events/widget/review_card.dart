import 'package:directorateofculture/Constant/color_manager.dart';
import 'package:directorateofculture/presentation/util/custom_text.dart';
import 'package:flutter/material.dart';

import 'event_model.dart';

class ReviewCard extends StatelessWidget {
  final ReviewInfo review;

  const ReviewCard({super.key, required this.review});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundImage: AssetImage(review.avatarAsset),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: CustomText(
                  review.reviewerName,
                  color: ColorManager.black,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: List.generate(5, (index) {
                  return Icon(
                    index < review.rating.round()
                        ? Icons.star
                        : Icons.star_border,
                    size: 14,
                    color: ColorManager.starRating,
                  );
                }),
              ),
            ],
          ),
          const SizedBox(height: 8),
          CustomText(review.comment, color: ColorManager.gray, fontSize: 12),
        ],
      ),
    );
  }
}
