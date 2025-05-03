import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tac/data/data/constants/app_colors.dart';
import 'package:tac/data/data/constants/app_typography.dart';
import 'package:tac/data/data/constants/app_assets.dart';
import 'package:tac/modules/Guards/job_details/CloseJobBottomSheet.dart';
import 'job_details_screen.dart';

class JobDetailsCancelScreen extends StatelessWidget {
  const JobDetailsCancelScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return JobDetailsScreen(
      bottomAction: const _CancelJobButton(),
    );
  }
}

class _CancelJobButton extends StatelessWidget {
  const _CancelJobButton();

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
                  // GetX bottom sheet call
                  Get.bottomSheet(
                    const CloseJobBottomSheet(),
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
                      "Cancel Job",
                      style: AppTypography.kBold16.copyWith(
                        color: AppColors.kRed,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Image.asset(
                      AppAssets.kCross,
                      height: 18,
                      width: 18,
                      color: AppColors.kRed,
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
