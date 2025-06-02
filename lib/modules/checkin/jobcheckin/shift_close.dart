import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taccontractor/data/data/constants/app_assets.dart';
import 'package:taccontractor/data/data/constants/app_colors.dart';
import 'package:taccontractor/data/data/constants/app_spacing.dart';
import 'package:taccontractor/data/data/constants/app_typography.dart';
import 'package:taccontractor/modules/checkin/jobcheckin/job_status_screen.dart';
import 'package:taccontractor/modules/checkin/jobcheckin/shift_close_controller.dart';

// class ShiftCloseController extends GetxController {
//   var selectedReason = ''.obs;
//   var customReason = ''.obs;

//   final reasons = [
//     'I have an emergency and need to leave',
//     'I am feeling unwell and cannot continue',
//     'There is a safety concern at the job site',
//     'Other (please specify)',
//   ];
// }

class ShiftCloseBottomSheet extends StatelessWidget {
  const ShiftCloseBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ShiftCloseController());
    final screenWidth = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.fifteenHorizontal,
          vertical: AppSpacing.twentyVertical,
        ),
        decoration: const BoxDecoration(
          color: AppColors.kDarkestBlue,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Drag Handle
              Container(
                width: 40,
                height: 4,
                margin: EdgeInsets.only(bottom: AppSpacing.fifteenVertical),
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),

              // Title
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Closing Shift Early?",
                  style: AppTypography.kBold17,
                ),
              ),
              SizedBox(height: AppSpacing.twelveVertical),
              const Divider(color: Colors.white24, thickness: 1),
              SizedBox(height: AppSpacing.twelveVertical),

              // Reason Container
              Container(
                padding: EdgeInsets.all(AppSpacing.fifteenHorizontal),
                decoration: BoxDecoration(
                  color: AppColors.kJobCardColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Please select your reason for ending the job",
                      style: AppTypography.kBold14
                          .copyWith(color: AppColors.kWhite),
                    ),
                    SizedBox(height: AppSpacing.twelveVertical),

                    // Custom Checkboxes
                    Obx(() => Column(
                          children: controller.reasons.map((reason) {
                            final isSelected =
                                controller.selectedReason.value == reason;
                            return GestureDetector(
                              onTap: () {
                                controller.selectedReason.value = reason;
                              },
                              child: Container(
                                margin: EdgeInsets.only(
                                    bottom: AppSpacing.twelveVertical),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 20,
                                      height: 20,
                                      margin: EdgeInsets.only(top: 2),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: isSelected
                                              ? AppColors.kPrimary
                                              : Colors.white38,
                                          width: 2,
                                        ),
                                        color: isSelected
                                            ? AppColors.kPrimary
                                            : Colors.transparent,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: isSelected
                                          ? const Icon(
                                              Icons.check,
                                              size: 16,
                                              color: Colors.black,
                                            )
                                          : null,
                                    ),
                                    SizedBox(
                                        width: AppSpacing.twelveHorizontal),
                                    Expanded(
                                      child: Text(
                                        reason,
                                        style: AppTypography.kLight14
                                            .copyWith(color: AppColors.kWhite),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        )),

                    SizedBox(height: AppSpacing.fifteenVertical),

                    // Share details input
                    TextField(
                      onChanged: (val) => controller.customReason.value = val,
                      maxLines: null,
                      style: AppTypography.kLight14
                          .copyWith(color: AppColors.kWhite),
                      cursorColor: AppColors.kPrimary,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: AppColors.kDarkestBlue,
                        hintText: "Share details (Optional)",
                        hintStyle: AppTypography.kLight14
                            .copyWith(color: Colors.white38),
                        prefixIcon: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Image.asset(AppAssets.kEdit,
                              width: 20, height: 20, color: Colors.white38),
                        ),
                        prefixIconConstraints:
                            const BoxConstraints(minWidth: 0, minHeight: 0),
                        contentPadding: EdgeInsets.symmetric(
                          vertical: AppSpacing.fifteenVertical,
                          horizontal: AppSpacing.twelveHorizontal,
                        ),
                        enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: AppColors.kPrimary),
                        ),
                        focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: AppColors.kPrimary),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: AppSpacing.twentyVertical),
              const Divider(color: Colors.white24, thickness: 1),
              SizedBox(height: AppSpacing.fifteenVertical),

              // Action Buttons
              Row(
                children: [
                  // Cancel button
                  SizedBox(
                    width: screenWidth * 0.28,
                    height: 44,
                    child: OutlinedButton(
                      onPressed: () => Get.back(),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.kPrimary),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        "Cancel",
                        style: AppTypography.kBold14
                            .copyWith(color: AppColors.kPrimary),
                      ),
                    ),
                  ),
                  SizedBox(width: AppSpacing.twelveHorizontal),

                  // End Job button
                  Expanded(
                    child: SizedBox(
                      height: 44,
                      child: ElevatedButton(
                        onPressed: () {
                          Get.to(() => const JobStatusScreenSuccess());
// or
// Get.to(() => const JobStatusScreenError());
                          // For Job Cancelled
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.kPrimary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          "End Job",
                          style: AppTypography.kBold14
                              .copyWith(color: AppColors.kBlack),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
