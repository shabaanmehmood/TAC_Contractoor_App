import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taccontractor/data/data/constants/app_assets.dart';
import 'package:taccontractor/data/data/constants/app_colors.dart';
import 'package:taccontractor/data/data/constants/app_spacing.dart';
import 'package:taccontractor/data/data/constants/app_typography.dart';
import 'package:taccontractor/models/job_model.dart';

import '../../../routes/app_routes.dart';

// Application submitted screen with error state
class JobPostedScreenError extends StatelessWidget {
  final JobData? jobData;
  final String message; // New field for API message
  JobPostedScreenError({super.key, required this.jobData, required this.message}); // require message

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kDarkestBlue,
      appBar: AppBar(
        backgroundColor: AppColors.kDarkestBlue,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Job Posting Failed',
          style: AppTypography.kBold16.copyWith(color: AppColors.kWhite),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: AppColors.kRed.withOpacity(0.1),
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(24),
                child: Icon(Icons.dangerous_outlined, size: 40, color: AppColors.kRed),
              ),
              const SizedBox(height: 24),
              Text(
                message,
                textAlign: TextAlign.center,
                style: AppTypography.kBold18.copyWith(color: AppColors.kWhite),
              ),
              const SizedBox(height: 12),
              Text(
                'We encountered an error while processing your request. \n Please try again later.',
                textAlign: TextAlign.center,
                style: AppTypography.kLight14.copyWith(color: AppColors.kinput),
              ),
              const SizedBox(height: 30),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.kJobCardColor,
                  borderRadius: BorderRadius.circular(3),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Error Code', style: AppTypography.kLight14.copyWith(color: AppColors.kgrey)),
                    const SizedBox(height: 4),
                    Text('ERR_NETWORK_FAILED', style: AppTypography.kBold14.copyWith(color: AppColors.kWhite)),
                    const SizedBox(height: 16),
                    Text('Suggested Action', style: AppTypography.kLight14.copyWith(color: AppColors.kgrey)),
                    const SizedBox(height: 4),
                    Text('Check your Internet connection or contact support', style: AppTypography.kBold14.copyWith(color: AppColors.kWhite)),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Get.offAndToNamed(AppRoutes.getLandingPageRoute()),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.kRed.withOpacity(0.2),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  child: Text(
                    "Retry ",
                    style: AppTypography.kBold16.copyWith(color: AppColors.kRed),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}