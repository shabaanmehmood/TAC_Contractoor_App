import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tac/data/data/constants/app_assets.dart';
import 'package:tac/data/data/constants/app_colors.dart';
import 'package:tac/data/data/constants/app_spacing.dart';
import 'package:tac/data/data/constants/app_typography.dart';

class ApplicationSubmittedScreen extends StatelessWidget {
  const ApplicationSubmittedScreen({super.key});

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
          'Application Submitted',
          style: AppTypography.kBold16.copyWith(color: AppColors.kWhite),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            const SizedBox(height: 40),
            // Check Icon
            Center(
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.kgreen.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(24),
                child: Icon(Icons.check, size: 40, color: AppColors.kgreen),
              ),
            ),
            const SizedBox(height: 24),
            // Message
            Text(
              'Your application has been\nsuccessfully submitted!',
              textAlign: TextAlign.center,
              style: AppTypography.kBold18.copyWith(color: AppColors.kWhite),
            ),
            const SizedBox(height: 32),
            // Job Card
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
                  Text(
                    'Job Title',
                    style:
                        AppTypography.kLight14.copyWith(color: AppColors.kgrey),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Security Escort for Actor – Airport to Residence',
                    style:
                        AppTypography.kBold14.copyWith(color: AppColors.kWhite),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Applied On',
                    style:
                        AppTypography.kLight14.copyWith(color: AppColors.kgrey),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Today, 9:41 AM',
                    style:
                        AppTypography.kBold14.copyWith(color: AppColors.kWhite),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Status',
                    style:
                        AppTypography.kLight14.copyWith(color: AppColors.kgrey),
                  ),
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
                        'Pending Employer Review',
                        style: AppTypography.kBold14
                            .copyWith(color: AppColors.kWhite),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),
            // Back to Jobs Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Get.back(), // or Get.toNamed('/jobs')
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.kSkyBlue,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.arrow_back, color: Colors.black),
                    const SizedBox(width: 8),
                    Text(
                      'Back to Jobs',
                      style: AppTypography.kBold16
                          .copyWith(color: AppColors.kDarkBlue),
                    ),
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
