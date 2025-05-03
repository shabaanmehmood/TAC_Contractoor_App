import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tac/data/data/constants/app_colors.dart';
import 'package:tac/data/data/constants/app_typography.dart';
import 'package:tac/data/data/constants/app_assets.dart';

class WithdrawJobBottomSheet extends StatelessWidget {
  const WithdrawJobBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
      decoration: const BoxDecoration(
        color: AppColors.kJobCardColor, // Assuming same as kDarkestBlue
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Text(
                "Withdraw Job",
                style: AppTypography.kBold20.copyWith(color: AppColors.kWhite),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () => Get.back(),
                child: Image.asset(AppAssets.kCross,
                    height: 20, width: 20, color: AppColors.kSkyBlue),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Job Title
          Text(
            "Security Escort for Actor – Airport to Residence",
            style: AppTypography.kBold16.copyWith(color: AppColors.kWhite),
          ),
          const SizedBox(height: 12),

          // Message
          Text(
            "Are you sure? You can to withdraw the job. This may cause the cancelation of the job and you have to pay some charges now.",
            style: AppTypography.kLight14.copyWith(color: AppColors.kgrey),
          ),
          const SizedBox(height: 24),

          // Buttons
          Row(
            children: [
              // No Button (text-only)
              Expanded(
                child: TextButton(
                  onPressed: () => Get.back(),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: Text(
                    "No, Don’t Cancel",
                    style: AppTypography.kBold14.copyWith(
                      color: AppColors.kgreen,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // Yes Button
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    // Withdraw logic here
                    Get.back();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.kRedS,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    "Yes, Please",
                    style: AppTypography.kBold14.copyWith(
                      color: AppColors.kRed,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
