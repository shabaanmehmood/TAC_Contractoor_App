// earnings_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tac/data/data/constants/app_typography.dart';
import 'package:tac/data/data/constants/app_colors.dart';
import 'package:tac/data/data/constants/app_spacing.dart';
import 'package:tac/modules/account/components/Earning/transcation.dart';
import 'earnings_controller.dart';
import 'earning_model.dart';
import 'package:tac/data/data/constants/app_assets.dart';

class EarningsScreen extends StatelessWidget {
  final EarningsController controller = Get.put(EarningsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kDarkestBlue,
      body: Column(
        children: [
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSpacing.twentyHorizontal,
                    vertical: AppSpacing.tenVertical,
                  ),
                  child: Row(
                    children: [
                      Image.asset(
                        AppAssets
                            .kBack, // Your custom path, e.g., 'assets/icons/back_arrow.png'
                        color: Colors.white, // Apply tint if needed
                        height: 24,
                        width: 24,
                      ),
                      SizedBox(width: AppSpacing.tenHorizontal),
                      Text(
                        'Earnings',
                        style:
                            AppTypography.kBold20.copyWith(color: Colors.white),
                      ),
                    ],
                  ),
                ),
                Divider(color: AppColors.kinput),
              ],
            ),
          ),

          // Earnings card
          Container(
            margin: EdgeInsets.only(
                top: AppSpacing.twentyFiveHorizontal,
                left: AppSpacing.twentyFiveHorizontal,
                right: AppSpacing.twentyFiveHorizontal),
            padding: EdgeInsets.all(
              AppSpacing.twentyHorizontal,
            ),
            decoration: BoxDecoration(
              color: AppColors.kDarkestBlue,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.kinput,
                width: 1,
              ),
            ),
            child: Obx(() {
              var total = controller.currentEarnings
                  .fold(0.0, (sum, e) => sum + e.amount);
              var hours = controller.currentEarnings.length * 8;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Total Balance",
                              style: AppTypography.kLight14
                                  .copyWith(color: AppColors.ktextlight)),
                          SizedBox(height: 6),
                          Text("\$${total.toStringAsFixed(2)}",
                              style: AppTypography.kBold32
                                  .copyWith(color: AppColors.kPrimary)),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text("Hours",
                              style: AppTypography.kLight14
                                  .copyWith(color: AppColors.ktextlight)),
                          SizedBox(height: 6),
                          Text("$hours",
                              style: AppTypography.kBold20
                                  .copyWith(color: AppColors.kPrimary)),
                        ],
                      ),
                    ],
                  ),
                ],
              );
            }),
          ),

// Choice chips (below the card)
          // Choice chips (in one row, evenly spaced and fixed size)
          SizedBox(height: AppSpacing.twentyVertical),
          Padding(
            padding:
                EdgeInsets.symmetric(horizontal: AppSpacing.twentyHorizontal),
            child: Obx(() {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(4, (index) {
                  bool isSelected = controller.selectedIndex.value == index;
                  return Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 4), // small spacing between chips
                      child: GestureDetector(
                        onTap: () => controller.selectIndex(index),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: AppSpacing.fiveVertical),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.kPrimary
                                : Colors.transparent,
                            border: Border.all(color: AppColors.kgrey),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            [
                              "This Week",
                              "Last Week",
                              "Last Month",
                              "Custom"
                            ][index],
                            style: AppTypography.kBold14.copyWith(
                              fontSize: 12,
                              color: isSelected
                                  ? Colors.white
                                  : AppColors.ktextlight,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              );
            }),
          ),

// Recent Earnings Text
          SizedBox(height: AppSpacing.fifteenVertical),
          Padding(
            padding:
                EdgeInsets.symmetric(horizontal: AppSpacing.twentyHorizontal),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "Recent Earnings",
                  style: AppTypography.kBold18.copyWith(color: Colors.white),
                ),
              ],
            ),
          ),

// Change this to exactly 10 pixels

          Expanded(
            child: Obx(() {
              var earnings = controller.currentEarnings;
              if (earnings.isEmpty) {
                return Center(
                  child: Text(
                    "No data available",
                    style:
                        AppTypography.kBold16.copyWith(color: AppColors.kWhite),
                  ),
                );
              }
              return ListView.builder(
                itemCount: earnings.length,
                itemBuilder: (_, index) {
                  final model = earnings[index];
                  return GestureDetector(
                    onTap: () {
                      Get.to(() => TransactionDetailsScreen(job: model));
                      print("Tapped on: ${model.title}");
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(
                        vertical: AppSpacing.tenVertical,
                        horizontal: AppSpacing.twentyHorizontal,
                      ),
                      padding: EdgeInsets.all(AppSpacing.fifteenHorizontal),
                      decoration: BoxDecoration(
                        color: AppColors.kJobCardColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            model.title,
                            style: AppTypography.kBold16
                                .copyWith(color: AppColors.kWhite),
                          ),
                          SizedBox(height: AppSpacing.fiveVertical),
                          Text(
                            model.date,
                            style: AppTypography.kLight14
                                .copyWith(color: AppColors.ktextlight),
                          ),
                          SizedBox(height: AppSpacing.fiveVertical),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                model.hours,
                                style: AppTypography.kLight14
                                    .copyWith(color: AppColors.ktextlight),
                              ),
                              Text(
                                "\$${model.amount.toStringAsFixed(2)}",
                                style: AppTypography.kBold16
                                    .copyWith(color: AppColors.kWhite),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
