import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:tac/data/data/constants/app_assets.dart';
import 'package:tac/data/data/constants/app_colors.dart';
import 'package:tac/data/data/constants/app_spacing.dart';
import 'package:tac/data/data/constants/app_typography.dart';
import 'package:tac/modules/checkin/jobcheckin/Submited_Review_Screen.dart';

class SubmitReviewScreen extends StatelessWidget {
  const SubmitReviewScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final RxDouble rating = 0.0.obs;
    final TextEditingController reviewController = TextEditingController();

    return Scaffold(
      backgroundColor: AppColors.kDarkestBlue,
      appBar: AppBar(
        backgroundColor: AppColors.kDarkestBlue,
        elevation: 0,
        leading: IconButton(
          icon: Image.asset(AppAssets.kBack, width: 24),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Submit Your Review',
          style: AppTypography.kBold16.copyWith(color: AppColors.kWhite),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.twentyHorizontal,
          vertical: AppSpacing.twentyVertical,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    'Security Escort for Actor – Airport to Residence',
                    style: AppTypography.kBold16.copyWith(
                      color: AppColors.kWhite,
                    ),
                  ),
                ),
                SizedBox(width: AppSpacing.tenHorizontal),
                Text(
                  '\$28/hr',
                  style: AppTypography.kBold16.copyWith(
                    color: AppColors.kSkyBlue,
                  ),
                  textAlign: TextAlign.right,
                ),
              ],
            ),
            SizedBox(height: AppSpacing.tenVertical),
            Text(
              'Hugh Jackman   Actor',
              style:
                  AppTypography.kLight14.copyWith(color: AppColors.ktextlight),
            ),
            SizedBox(height: AppSpacing.fiveVertical),
            Row(
              children: [
                Image.asset(AppAssets.kCal, width: 16),
                SizedBox(width: 8),
                Text(
                  '24 Mar 2025',
                  style: AppTypography.kLight14
                      .copyWith(color: AppColors.ktextlight),
                ),
                SizedBox(width: 16),
                Image.asset(AppAssets.kTime, width: 16),
                SizedBox(width: 8),
                Text(
                  '9:00 AM – 5:00 PM',
                  style: AppTypography.kLight14
                      .copyWith(color: AppColors.ktextlight),
                ),
              ],
            ),
            SizedBox(height: AppSpacing.twentyVertical),
            Text(
              'Rate this Job',
              style: AppTypography.kBold16.copyWith(color: AppColors.kWhite),
            ),
            SizedBox(height: AppSpacing.tenVertical),
            Obx(() {
              return RatingBar.builder(
                initialRating: rating.value,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: false,
                itemCount: 5,
                itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                unratedColor: Colors.grey[700],
                itemBuilder: (context, _) => Icon(
                  Icons.star,
                  color: AppColors.kPrimary,
                ),
                onRatingUpdate: (value) {
                  rating.value = value;
                },
              );
            }),
            SizedBox(height: AppSpacing.twentyVertical),
            Text(
              'Write your review',
              style: AppTypography.kBold16.copyWith(color: AppColors.kWhite),
            ),
            SizedBox(height: AppSpacing.tenVertical),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: AppColors.kPrimary, width: 1),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(AppAssets.kPen, width: 18),
                  SizedBox(width: AppSpacing.tenHorizontal),
                  Expanded(
                    child: TextFormField(
                      controller: reviewController,
                      maxLines: 3,
                      style: AppTypography.kLight14.copyWith(
                        color: AppColors.kWhite,
                      ),
                      decoration: InputDecoration(
                        hintText:
                            'Share your experience with this job and employer',
                        hintStyle: AppTypography.kLight14.copyWith(
                          color: AppColors.kgrey,
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.kSkyBlue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  Get.to(() => const ReviewSubmittedScreen());
                  print('Rating: ${rating.value}');
                  print('Review: ${reviewController.text}');
                },
                child: Text(
                  'Submit Review',
                  style: AppTypography.kBold16
                      .copyWith(color: AppColors.kDarkBlue),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
