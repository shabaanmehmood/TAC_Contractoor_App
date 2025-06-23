import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taccontractor/data/data/constants/app_assets.dart';
import 'package:taccontractor/data/data/constants/app_colors.dart';
import 'package:taccontractor/data/data/constants/app_spacing.dart';
import 'package:taccontractor/data/data/constants/app_typography.dart';
import 'package:taccontractor/models/job_model.dart';
import 'package:taccontractor/routes/app_routes.dart';

import '../../auth/signup_screens/CompanyInfoScreen.dart';

class JobPostedScreen extends StatelessWidget {
  final JobData? jobdata;
  final String message;  // New field for API message

  JobPostedScreen({super.key, required this.jobdata, required this.message});  // require message

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
          'Job Posting Successful',
          style: AppTypography.kBold16.copyWith(color: AppColors.kWhite),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Row(
              children: const [
                StepTab(title: "Job Details", isCompleted: true),
                StepTab(title: "Preferences", isCompleted: true,),
                StepTab(title: "Required Docs", isCompleted: true,),
              ],
            ),
            const SizedBox(height: 40),
            Center(
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.kgreen.withOpacity(0.1),
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(24),
                child: Icon(Icons.check, size: 40, color: AppColors.kgreen),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTypography.kBold18.copyWith(color: AppColors.kWhite),
            ),
            const SizedBox(height: 12),
            Text(
              'Your job listing is live now and visible to potential candidates.',
              textAlign: TextAlign.center,
              style: AppTypography.kLight14.copyWith(color: AppColors.kinput),
            ),
            // ... rest of your UI unchanged
            const SizedBox(height: 32),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.kJobCardColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Job Title', style: AppTypography.kLight14.copyWith(color: AppColors.kgrey)),
                  const SizedBox(height: 4),
                  Text(jobdata!.title, style: AppTypography.kBold14.copyWith(color: AppColors.kWhite)),
                  const SizedBox(height: 16),
                  Text('Applied On', style: AppTypography.kLight14.copyWith(color: AppColors.kgrey)),
                  const SizedBox(height: 4),
                  Text(DateTime.now().toString(), style: AppTypography.kBold14.copyWith(color: AppColors.kWhite)),
                  const SizedBox(height: 16),
                  Text('Status', style: AppTypography.kLight14.copyWith(color: AppColors.kgrey)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: AppColors.kalert,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        message,  // Show the message here as status too
                        style: AppTypography.kBold14.copyWith(color: AppColors.kWhite),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Get.offAndToNamed(AppRoutes.getLandingPageRoute()); // Navigate to guards page route
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.kDarkestBlue,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  side: BorderSide(
                    color: AppColors.kSkyBlue,
                    width: 2,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Open Job', style: AppTypography.kBold16.copyWith(color: AppColors.kSkyBlue)),
                    const SizedBox(width: 8),
                    Icon(Icons.arrow_forward_ios, color: AppColors.kSkyBlue),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Get.offAndToNamed(AppRoutes.getLandingPageRoute()); // Navigate to guards page route
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.kSkyBlue,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.arrow_back_ios, color: Colors.black),
                    const SizedBox(width: 8),
                    Text('Back to Home', style: AppTypography.kBold16.copyWith(color: AppColors.kDarkBlue)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
