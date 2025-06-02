import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taccontractor/data/data/constants/app_typography.dart';
import 'package:taccontractor/data/data/constants/app_colors.dart';
import 'package:taccontractor/data/data/constants/app_spacing.dart';
import 'earning_model.dart';
import 'package:taccontractor/data/data/constants/app_assets.dart';

class TransactionDetailsScreen extends StatelessWidget {
  final EarningModel job;

  const TransactionDetailsScreen({Key? key, required this.job})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kDarkestBlue,
      appBar: AppBar(
        backgroundColor: AppColors.kDarkestBlue,
        elevation: 0,
        leading: IconButton(
          icon: Image.asset(
            AppAssets
                .kBack, // This should be the path to your asset (e.g., 'assets/icons/abn.png')
            color: AppColors.kWhite, // Optional: tint the image
            height: 30, // Adjust size as needed
            width: 30,
          ),
          onPressed: () => Get.back(),
        ),
        title: Text('Transaction Details',
            style: AppTypography.kBold20.copyWith(color: AppColors.kWhite)),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: AppSpacing.twentyHorizontal),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.symmetric(vertical: AppSpacing.twentyVertical),
              padding: EdgeInsets.all(AppSpacing.fifteenHorizontal),
              decoration: BoxDecoration(
                color: AppColors.kJobCardColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Residential Security Guard',
                      style: AppTypography.kBold18
                          .copyWith(color: AppColors.kWhite)),
                  SizedBox(height: AppSpacing.fiveVertical),
                  Text('March 15, 2024',
                      style: AppTypography.kLight14
                          .copyWith(color: AppColors.kgrey)),
                  SizedBox(height: AppSpacing.tenVertical),
                  GestureDetector(
                    onTap: () => Get.toNamed('/jobDetails'),
                    child: Text(
                      'Job Details',
                      style: AppTypography.kBold14.copyWith(
                          color: AppColors.kPrimary,
                          decoration: TextDecoration.underline),
                    ),
                  ),
                  SizedBox(height: AppSpacing.tenVertical),
                  Row(
                    children: [
                      Text('#236589685955',
                          style: AppTypography.kLight14
                              .copyWith(color: AppColors.kgrey)),
                      const Spacer(),
                      const Icon(Icons.copy, color: AppColors.kWhite, size: 16)
                    ],
                  ),
                  SizedBox(height: AppSpacing.tenVertical),
                  Text('\$2,450.00',
                      style: AppTypography.kBold24
                          .copyWith(color: AppColors.kPrimary)),
                  SizedBox(height: AppSpacing.fiveVertical),
                  Text('82 hours @ \$30/hr',
                      style: AppTypography.kLight14
                          .copyWith(color: AppColors.kgrey)),
                ],
              ),
            ),
            Text('Screenshot',
                style: AppTypography.kBold16.copyWith(color: AppColors.kWhite)),
            SizedBox(height: AppSpacing.tenVertical),
            Container(
              height: Get.height * 0.25,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: AppColors.kJobCardColor,
              ),
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(AppSpacing.tenHorizontal),
                  child: Image.asset(
                    'assets/apple.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.kPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: EdgeInsets.symmetric(
                      vertical: AppSpacing.fifteenVertical),
                ),
                child: Text(
                  'Save Screenshot',
                  style:
                      AppTypography.kBold16.copyWith(color: AppColors.kWhite),
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
