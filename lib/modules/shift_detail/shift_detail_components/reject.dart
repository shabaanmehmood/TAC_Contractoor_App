import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taccontractor/data/data/constants/app_colors.dart';
import 'package:taccontractor/data/data/constants/app_typography.dart';

class RejectingShiftBottomSheet extends StatefulWidget {
  @override
  State<RejectingShiftBottomSheet> createState() => _RejectingShiftBottomSheetState();
}

class _RejectingShiftBottomSheetState extends State<RejectingShiftBottomSheet> {
  final List<String> reasons = [
    "Selfie is unclear.",
    "late-clock-in",
    "Incomplete uniform or improper code dress",
    "Supicious activity detected",
    "clock-in-outside permitted time window",
  ];

  // 👇 NEW: Store multiple selected indexes
  Set<int> selectedIndexes = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kDarkBlue,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: Get.height * 0.04),

              /// Drag Handle
              Center(
                child: Container(
                  width: Get.width * 0.35,
                  height: 6,
                  margin: EdgeInsets.only(bottom: Get.height * 0.02),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade700,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),

              /// Title
              Padding(
                padding: EdgeInsets.only(top: Get.height * 0.02, left: Get.height * 0.02),
                child: Text(
                  "Rejecting Guard Shift",
                  style: AppTypography.kBold18.copyWith(color: AppColors.kWhite),
                ),
              ),
              SizedBox(height: Get.height * 0.02),

              /// Divider
              Container(
                width: double.infinity,
                height: Get.width * 0.002,
                color: AppColors.kWhite,
              ),

              /// Subtitle
              Padding(
                padding: EdgeInsets.only(top: Get.height * 0.02, left: Get.height * 0.02),
                child: Text(
                  "Are you sure you want to reject the guard’s clock-in request?",
                  style: AppTypography.kBold14.copyWith(color: AppColors.kWhite),
                ),
              ),
              SizedBox(height: Get.height * 0.025),

              /// Reason Box
              Padding(
                padding: EdgeInsets.symmetric(horizontal: Get.height * 0.02),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(Get.width * 0.04),
                  decoration: BoxDecoration(
                    color: AppColors.kgrey.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Please select your reason",
                        style: AppTypography.kBold14.copyWith(color: AppColors.kWhite),
                      ),
                      SizedBox(height: Get.height * 0.015),

                      /// Multi-select checkbox list
                      ...List.generate(reasons.length, (index) {
                        return Padding(
                          padding: EdgeInsets.only(bottom: Get.height * 0.012),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                if (selectedIndexes.contains(index)) {
                                  selectedIndexes.remove(index);
                                } else {
                                  selectedIndexes.add(index);
                                }
                              });
                            },
                            child: Row(
                              children: [
                                Icon(
                                  selectedIndexes.contains(index)
                                      ? Icons.check_box
                                      : Icons.check_box_outline_blank,
                                  color: AppColors.kgrey,
                                  size: Get.width * 0.05,
                                ),
                                SizedBox(width: Get.width * 0.025),
                                Expanded(
                                  child: Text(
                                    reasons[index],
                                    style: AppTypography.kLight14.copyWith(color: AppColors.kWhite),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),

                      SizedBox(height: Get.height * 0.02),

                      /// Optional Text Field
                      Container(
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: AppColors.kACardAlert, width: 1),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.edit, color: AppColors.kgrey, size: Get.width * 0.05),
                            SizedBox(width: Get.width * 0.02),
                            Expanded(
                              child: TextField(
                                style: AppTypography.kLight14.copyWith(color: AppColors.kWhite),
                                cursorColor: AppColors.kWhite,
                                decoration: InputDecoration(
                                  hintText: "Share details (Optional)",
                                  hintStyle: AppTypography.kLight14.copyWith(color: AppColors.kgrey),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: Get.height * 0.03),

              /// Buttons Row
              Padding(
                padding: EdgeInsets.symmetric(horizontal: Get.height * 0.02),
                child: Row(
                  children: [
                    /// Cancel Button
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: AppColors.kSkyBlue),
                          padding: EdgeInsets.symmetric(vertical: Get.height * 0.018),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(Get.width * 0.02),
                          ),
                        ),
                        onPressed: () => Get.back(),
                        child: Text(
                          "Cancel",
                          style: AppTypography.kBold14.copyWith(color: AppColors.kSkyBlue),
                        ),
                      ),
                    ),
                    SizedBox(width: Get.width * 0.04),

                    /// Cancel Shift Button
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          // Example: print selected reasons
                          final selectedReasons = selectedIndexes.map((i) => reasons[i]).toList();
                          print("Selected Reasons: $selectedReasons");
                        },
                        child: Container(
                          height: Get.height * 0.07,
                          decoration: BoxDecoration(
                            color: AppColors.kACardCancelled.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(Get.width * 0.02),
                          ),
                          child: Center(
                            child: Text(
                              "Reject Request",
                              style: AppTypography.kBold16.copyWith(
                                color: AppColors.kACardCancelled,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
