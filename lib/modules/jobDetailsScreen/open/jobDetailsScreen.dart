import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taccontractor/data/data/constants/app_assets.dart';
import 'package:taccontractor/data/data/constants/app_colors.dart';
import 'package:taccontractor/data/data/constants/app_typography.dart';
import 'package:taccontractor/dataproviders/api_service.dart';
import 'package:taccontractor/modules/jobDetailsScreen/open/details.dart';
import 'package:taccontractor/modules/jobDetailsScreen/open/guards.dart';
import 'package:taccontractor/modules/jobDetailsScreen/open/shift.dart';
import 'package:taccontractor/modules/jobDetailsScreen/open/timelines.dart';

import '../../../models/myJobs_model.dart';

class ContractorOpenJobDetailsScreen extends StatefulWidget {
  final MyjobsModel job;
  const ContractorOpenJobDetailsScreen({super.key, required this.job});

  @override
  State<ContractorOpenJobDetailsScreen> createState() =>
      _ContractorOpenJobDetailsScreenState();
}

class _ContractorOpenJobDetailsScreenState
    extends State<ContractorOpenJobDetailsScreen> {
  final List<String> tabs = ["Details", "Shifts", "Guards", "Timeline"];
  int selectedIndex = 0;

  Widget getSelectedWidget() {
    switch (selectedIndex) {
      case 0:
        return openDetailsWidget(widget.job);
      case 1:
        return openShiftCard(widget.job);
      case 2:
        return openGuards();
      case 3:
        return openTimeline();
      default:
        return openDetailsWidget(widget.job);
    }
  }

  void _showCancelConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.kDarkBlue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: Row(
            children: [
              Icon(Icons.warning, color: AppColors.kRed, size: 24),
              SizedBox(width: 10),
              Text(
                "Cancel Job?",
                style: AppTypography.kBold18.copyWith(color: AppColors.kWhite),
              ),
            ],
          ),
          content: Text(
            "Are you sure you want to cancel this job? This action cannot be undone.",
            style: AppTypography.kLight14.copyWith(color: AppColors.kgrey),
          ),
          actions: [
            // Don't Cancel Button
            OutlinedButton(
              onPressed: () => Get.back(),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: AppColors.kSkyBlue),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
              child: Text(
                "Don't Cancel",
                style:
                    AppTypography.kBold14.copyWith(color: AppColors.kSkyBlue),
              ),
            ),
            // Yes Cancel Button
            ElevatedButton(
              onPressed: () {
                Get.back();
                _cancelJob();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromRGBO(235, 0, 0, 0.15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
              child: Text(
                "Yes, Cancel",
                style: AppTypography.kBold14.copyWith(
                  color: Color(0xFFDA4E46),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // Cancel job functionality
  void _cancelJob() async {
    // Show loading
    Get.dialog(
      Center(
        child: CircularProgressIndicator(color: AppColors.kRed),
      ),
      barrierDismissible: false,
    );

    // Call API to delete job
    final result = await MyApIService().deleteJob(widget.job.jobId);

    // Close loading dialog
    Get.back();

    if (result['success'] == true) {
      // Show success message
      Get.snackbar(
        "Job Cancelled",
        result['message'] ?? "Job has been cancelled successfully",
        backgroundColor: Color.fromRGBO(235, 0, 0, 0.15),
        colorText: Color(0xFFDA4E46),
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 3),
      );

      // Navigate back after successful cancellation
      Future.delayed(Duration(seconds: 2), () {
        Get.back(result: 'deleted'); // You can pass result to previous screen
      });
    } else {
      // Show error message
      Get.snackbar(
        "Cancellation Failed",
        result['message'] ?? "Failed to cancel job",
        backgroundColor: AppColors.kRed,
        colorText: AppColors.kWhite,
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 3),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kDarkBlue,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Header
            Padding(
              padding: EdgeInsets.only(
                  top: Get.height * 0.02, left: Get.height * 0.02),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Image.asset(
                      AppAssets.kBack,
                      height: Get.height * 0.07,
                      width: Get.width * 0.07,
                      fit: BoxFit.contain,
                      color: AppColors.kgrey,
                    ),
                  ),
                  SizedBox(width: Get.width * 0.04),
                  Text(
                    "Job Details",
                    style:
                        AppTypography.kBold20.copyWith(color: AppColors.kWhite),
                  ),
                ],
              ),
            ),

            /// Divider
            Container(
              width: double.infinity,
              height: Get.width * 0.002,
              color: AppColors.kgrey,
            ),

            /// Job ID and Status
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: Get.height * 0.02, vertical: Get.height * 0.02),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  _buildStatusChip(
                    widget.job.jobStatus?.toUpperCase() ?? "",
                    AppColors.kblueCard.withOpacity(0.5),
                    AppColors.kblueCard,
                  ),
                ],
              ),
            ),

            /// Job Title & Pay
            Padding(
              padding: EdgeInsets.symmetric(horizontal: Get.height * 0.02),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      widget.job.jobTitle,
                      style: AppTypography.kBold20
                          .copyWith(color: AppColors.kWhite),
                    ),
                  ),
                  Text(
                    '\$ ${widget.job.payPerHour}/hr',
                    style: AppTypography.kBold20
                        .copyWith(color: Colors.cyanAccent),
                  ),
                ],
              ),
            ),

            SizedBox(height: Get.height * 0.01),

            /// Date & Location
            Padding(
              padding: EdgeInsets.symmetric(horizontal: Get.height * 0.02),
              child: Container(
                padding: EdgeInsets.symmetric(
                    horizontal: Get.width * 0.03, vertical: Get.width * 0.03),
                decoration: BoxDecoration(
                  color: AppColors.kinput.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(Get.width * 0.01),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Image.asset("assets/icon/jobCalender.png",
                            scale: Get.width * 0.0025, color: AppColors.kgrey),
                        SizedBox(width: 5),
                        Text(
                          widget.job.shifts.first.date,
                          style: AppTypography.kLight14.copyWith(
                              color: Color.fromARGB(255, 180, 189, 209)),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.location_on,
                            color: AppColors.kgrey, size: 18),
                        SizedBox(width: 5),
                        Expanded(
                          child: Text(
                            widget.job.jobLocation,
                            style: AppTypography.kLight14
                                .copyWith(color: AppColors.kgrey),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: Get.height * 0.02),

            /// Tabs
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.only(left: Get.width * 0.03),
              child: Row(
                children: List.generate(tabs.length, (index) {
                  final isSelected = selectedIndex == index;
                  return Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: Get.width * 0.015),
                    child: OutlinedButton(
                      onPressed: () {
                        setState(() {
                          selectedIndex = index;
                        });
                      },
                      style: OutlinedButton.styleFrom(
                        backgroundColor: isSelected
                            ? AppColors.kSkyBlue
                            : Colors.transparent,
                        side: BorderSide(color: AppColors.kSkyBlue),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(Get.width * 0.02),
                        ),
                        padding: EdgeInsets.symmetric(
                            horizontal: Get.width * 0.03,
                            vertical: Get.width * 0.01),
                      ),
                      child: Text(
                        tabs[index],
                        style: AppTypography.kBold16.copyWith(
                          color:
                              isSelected ? AppColors.kBlack : AppColors.kWhite,
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),

            SizedBox(height: Get.height * 0.015),

            /// Selected Tab Content
            Expanded(
              child: getSelectedWidget(),
            ),

            /// ADDED: Cancel Job Button at Bottom (same as active screen)
            Padding(
              padding: EdgeInsets.all(Get.height * 0.02),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _showCancelConfirmationDialog,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromRGBO(235, 0, 0, 0.15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(Get.width * 0.02),
                    ),
                    padding: EdgeInsets.symmetric(vertical: Get.height * 0.018),
                    elevation: 2,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Cancel Job",
                        style: AppTypography.kBold16.copyWith(
                            color: Color(0xFFDA4E46),
                            fontWeight: FontWeight.w600),
                      ),
                      SizedBox(width: 8),
                      Icon(
                        Icons.cancel_outlined,
                        color: Color(0xFFDA4E46),
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(String label, Color color1, Color color2) {
    return OutlinedButton(
      onPressed: () {},
      style: OutlinedButton.styleFrom(
        backgroundColor: color1,
        side: BorderSide(color: color1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Get.width * 0.02),
        ),
        padding: EdgeInsets.symmetric(
            horizontal: Get.width * 0.03, vertical: Get.width * 0.01),
      ),
      child: Text(label, style: AppTypography.kLight14.copyWith(color: color2)),
    );
  }
}
