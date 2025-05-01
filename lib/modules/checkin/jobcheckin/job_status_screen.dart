import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tac/data/data/constants/app_assets.dart';
import 'package:tac/data/data/constants/app_colors.dart';
import 'package:tac/data/data/constants/app_spacing.dart';
import 'package:tac/data/data/constants/app_typography.dart';

class JobStatusScreenSuccess extends StatelessWidget {
  const JobStatusScreenSuccess({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kDarkestBlue,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                        horizontal: AppSpacing.twentyHorizontal),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: AppSpacing.twentyVertical),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () => Get.back(),
                              child: Image.asset(AppAssets.kBack, height: 24),
                            ),
                            SizedBox(width: 12),
                            Text(
                              "Job Completed",
                              style: AppTypography.kBold20
                                  .copyWith(color: AppColors.kWhite),
                            )
                          ],
                        ),
                        SizedBox(height: AppSpacing.thirtyVertical),
                        Container(
                          height: 60,
                          width: 60,
                          decoration: BoxDecoration(
                            color: AppColors.kGreenS,
                            shape: BoxShape.circle,
                          ),
                          child:
                              Icon(Icons.check, size: 36, color: Colors.green),
                        ),
                        SizedBox(height: AppSpacing.twentyVertical),
                        Text(
                          "Your job has been successfully completed!",
                          textAlign: TextAlign.center,
                          style: AppTypography.kBold18
                              .copyWith(color: AppColors.kWhite),
                        ),
                        SizedBox(height: AppSpacing.thirtyVertical),
                        _JobDetailsCard(),
                        SizedBox(height: AppSpacing.twentyVertical),
                        _ShiftDetailsCard(),
                        SizedBox(height: AppSpacing.twentyVertical),
                        _BottomActionButtons(), // ← Now it's scrollable!
                        SizedBox(height: AppSpacing.twentyVertical),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _JobDetailsCard() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.kJobCardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Job Details",
              style: AppTypography.kBold16.copyWith(color: AppColors.kWhite)),
          SizedBox(height: 12),
          Text("Security Escort for Actor – Airport to Residence",
              style: AppTypography.kBold14.copyWith(color: AppColors.kWhite)),
          SizedBox(height: 6),
          Text("Hugh Jackman    Actor",
              style: AppTypography.kLight14.copyWith(color: AppColors.kgrey)),
          SizedBox(height: 6),
          Row(
            children: [
              Image.asset(AppAssets.kLoc, height: 18),
              SizedBox(width: 6),
              Expanded(
                  child: Text("2972 Westheimer Rd. Santa Ana, Illinois 85486",
                      style: AppTypography.kLight14
                          .copyWith(color: AppColors.kgrey))),
            ],
          ),
          SizedBox(height: 6),
          Row(
            children: [
              Image.asset(AppAssets.kCal, height: 18),
              SizedBox(width: 6),
              Text("Today   9:00 AM - 5:00 PM",
                  style:
                      AppTypography.kLight14.copyWith(color: AppColors.kgrey)),
            ],
          )
        ],
      ),
    );
  }

  Widget _ShiftDetailsCard() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.kJobCardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Shift Details",
              style: AppTypography.kBold16.copyWith(color: AppColors.kWhite)),
          SizedBox(height: 12),
          _shiftRow("Start Time", "Today, 9:00 AM"),
          _shiftRow("End Time", "Today, 5:00 PM"),
          _shiftRow("Rate Per Hour", "\$28/hr"),
          _shiftRow("Hours Worked", "8"),
          _shiftRow("Tip", "\$0"),
          _shiftRow("Total Earning", "\$224"),
        ],
      ),
    );
  }

  Widget _shiftRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style: AppTypography.kLight14.copyWith(color: AppColors.kgrey)),
          Text(value,
              style: AppTypography.kBold14.copyWith(color: AppColors.kWhite)),
        ],
      ),
    );
  }

  Widget _BottomActionButtons() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: Text("Share Your Review!",
                style:
                    AppTypography.kBold16.copyWith(color: AppColors.kSkyBlue)),
          ),
          SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.kPrimary,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              onPressed: () {
                // Navigate to next job screen
                Get.toNamed('/nextJob');
              },
              child: Text("Check My Next Job",
                  style:
                      AppTypography.kBold16.copyWith(color: AppColors.kWhite)),
            ),
          ),
          SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.kSkyBlue,
                side: BorderSide(color: AppColors.kSkyBlue),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              onPressed: () => Get.back(),
              icon: Icon(Icons.arrow_back, size: 20),
              label: Text("Back to Jobs",
                  style: AppTypography.kBold16
                      .copyWith(color: AppColors.kSkyBlue)),
            ),
          ),
        ],
      ),
    );
  }
}
