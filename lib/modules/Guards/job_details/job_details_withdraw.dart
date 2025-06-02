import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taccontractor/data/data/constants/app_colors.dart';
import 'package:taccontractor/data/data/constants/app_typography.dart';
import 'package:taccontractor/data/data/constants/app_assets.dart';
import 'package:taccontractor/modules/Guards/job_details/WithdrawJobBottomSheet.dart';
import 'job_details_screen.dart';

class JobDetailsWithdrawScreen extends StatelessWidget {
  const JobDetailsWithdrawScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return JobDetailsScreen(
      bottomAction: const _WithdrawButton(),
    );
  }
}

class _WithdrawButton extends StatelessWidget {
  const _WithdrawButton();

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            color: AppColors.kBlack,
            child: Divider(
              height: 1,
              thickness: 1,
              color: AppColors.kgrey.withOpacity(0.3),
            ),
          ),
          Container(
            color: AppColors.kBlack,
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Get.bottomSheet(
                    const WithdrawJobBottomSheet(),
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.kRedS,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Withdraw",
                      style: AppTypography.kBold16.copyWith(
                        color: AppColors.kWhite,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Image.asset(
                      AppAssets.kSend,
                      height: 18,
                      width: 18,
                      color: AppColors.kWhite,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
