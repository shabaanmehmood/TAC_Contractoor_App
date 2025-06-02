import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taccontractor/data/data/constants/app_assets.dart';
import 'package:taccontractor/data/data/constants/app_colors.dart';
import 'package:taccontractor/data/data/constants/app_spacing.dart';
import 'package:taccontractor/data/data/constants/app_typography.dart';

class ReviewSubmittedScreen extends StatelessWidget {
  const ReviewSubmittedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
          'Review Submitted',
          style: AppTypography.kBold16.copyWith(color: AppColors.kWhite),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: AppSpacing.twentyHorizontal),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 60),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check,
                size: 48,
                color: Colors.green,
              ),
            ),
            SizedBox(height: AppSpacing.twentyVertical),
            Text(
              'Your review has been\nsuccessfully submitted!',
              textAlign: TextAlign.center,
              style: AppTypography.kBold18.copyWith(color: AppColors.kWhite),
            ),
            SizedBox(height: AppSpacing.thirtyVertical),
            Align(
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Job Title',
                    style: AppTypography.kLight14.copyWith(
                      color: AppColors.ktextlight,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Security Escort for Actor – Airport to Residence',
                    style: AppTypography.kBold14.copyWith(
                      color: AppColors.kWhite,
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.kSkyBlue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  // Navigate back to jobs screen
                },
                icon: Image.asset(
                  AppAssets.kBack,
                  width: 20,
                  color: AppColors.kDarkBlue,
                ),
                label: Text(
                  'Back to Jobs',
                  style: AppTypography.kBold16
                      .copyWith(color: AppColors.kDarkBlue),
                ),
              ),
            ),
            SizedBox(height: AppSpacing.twentyVertical),
          ],
        ),
      ),
    );
  }
}
