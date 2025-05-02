import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tac/data/data/constants/app_assets.dart';
import 'package:tac/data/data/constants/app_colors.dart';
import 'package:tac/data/data/constants/app_spacing.dart';
import 'package:tac/data/data/constants/app_typography.dart';

class ApplicationSubmittedScreenError extends StatelessWidget {
  const ApplicationSubmittedScreenError({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kDarkestBlue,
      appBar: AppBar(
        backgroundColor: AppColors.kDarkestBlue,
        elevation: 0,
        leading: IconButton(
          icon: Image.asset(AppAssets.kBack, color: AppColors.kWhite),
          onPressed: () => Get.back(),
        ),
        title: Text(
          "Application Error",
          style: AppTypography.kBold16.copyWith(color: AppColors.kWhite),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Divider(
            height: 1,
            thickness: 1,
            color: AppColors.kgrey.withOpacity(0.3),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Image.asset(
                    AppAssets.kDanger,
                    width: 36,
                    height: 36,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  "Oops! Something went wrong.\nPlease try again.",
                  style: AppTypography.kBold16.copyWith(
                    color: AppColors.kWhite,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
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
                      Text("Error Code",
                          style: AppTypography.kLight14
                              .copyWith(color: AppColors.kgrey)),
                      const SizedBox(height: 4),
                      Text("#1234",
                          style: AppTypography.kBold14
                              .copyWith(color: AppColors.kWhite)),
                      const SizedBox(height: 16),
                      Text("Suggested Action",
                          style: AppTypography.kLight14
                              .copyWith(color: AppColors.kgrey)),
                      const SizedBox(height: 4),
                      Text(
                        "Check your internet connection or contact support.",
                        style: AppTypography.kBold14
                            .copyWith(color: AppColors.kWhite),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 25),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // Retry logic
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.kRedS,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    icon: Image.asset(
                      AppAssets.kRefresh,
                      width: 24,
                      height: 24,
                    ),
                    label: Text(
                      "Retry",
                      style:
                          AppTypography.kBold16.copyWith(color: AppColors.kRed),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
