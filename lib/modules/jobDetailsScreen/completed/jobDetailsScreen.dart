import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taccontractor/data/data/constants/app_assets.dart';
import 'package:taccontractor/data/data/constants/app_colors.dart';
import 'package:taccontractor/data/data/constants/app_typography.dart';
import 'package:taccontractor/modules/jobDetailsScreen/completed/details.dart';
import 'package:taccontractor/modules/jobDetailsScreen/completed/guards.dart';
import 'package:taccontractor/modules/jobDetailsScreen/completed/shift.dart';
import 'package:taccontractor/modules/jobDetailsScreen/completed/timelines.dart';


class ContractorCompletedJobDetailsScreen extends StatefulWidget {
  const ContractorCompletedJobDetailsScreen({super.key});

  @override
  State<ContractorCompletedJobDetailsScreen> createState() =>
      _ContractorCompletedJobDetailsScreenState();
}

class _ContractorCompletedJobDetailsScreenState
    extends State<ContractorCompletedJobDetailsScreen> {
  final List<String> tabs = ["Details", "Shifts", "Guards", "Timeline"];
  int selectedIndex = 0;

  Widget getSelectedWidget() {
    switch (selectedIndex) {
      case 0:
        return completedDetailsWidget();   
      case 1:
        return completedShiftCard();   
      case 2:
        return completedGuards();    
      case 3:
        return completedTimeline();  
      default:
        return completedDetailsWidget();
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
            padding: EdgeInsets.only(top: Get.height * 0.02, left: Get.height * 0.02),
            child: Row(
              children: [
                Image.asset(
                  AppAssets.kBack,
                  height: Get.height * 0.07,
                  width: Get.width * 0.07,
                  fit: BoxFit.contain,
                  color: AppColors.kgrey,
                ),
                SizedBox(width: Get.width * 0.04),
                Text(
                  "Job Details",
                  style: AppTypography.kBold20.copyWith(color: AppColors.kWhite),
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                  _buildStatusChip("#JOB-2024-021B",AppColors.kgrey,AppColors.kWhite),
                  _buildStatusChip("COMPLTETED",AppColors.kblueCard.withOpacity(0.5),AppColors.kblueCard),
    
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
                    'Security Escort for Actor – Airport to Residence',
                    style: AppTypography.kBold20.copyWith(color: AppColors.kWhite),
                  ),
                ),
                Text(
                  '\$ 28/hr',
                  style: AppTypography.kBold20.copyWith(color: Colors.cyanAccent),
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
                        '29 Mar 2025',
                        style: AppTypography.kLight14.copyWith(
                            color: Color.fromARGB(255, 180, 189, 209)),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.location_on, color: AppColors.kgrey, size: 18),
                      SizedBox(width: 5),
                      Expanded(
                        child: Text(
                          'Downtown Manhattan, NY, KENTUCKY 3459',
                          style: AppTypography.kLight14.copyWith(color: AppColors.kgrey),
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
                  padding: EdgeInsets.symmetric(horizontal: Get.width * 0.015),
                  child: OutlinedButton(
                    onPressed: () {
                      setState(() {
                        selectedIndex = index;
                      });
                    },
                    style: OutlinedButton.styleFrom(
                      backgroundColor:
                          isSelected ? AppColors.kSkyBlue : Colors.transparent,
                      side: BorderSide(color: AppColors.kSkyBlue),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(Get.width * 0.02),
                      ),
                      padding: EdgeInsets.symmetric(
                          horizontal: Get.width * 0.03, vertical: Get.width * 0.01),
                    ),
                    child: Text(
                      tabs[index],
                      style: AppTypography.kBold16.copyWith(
                        color: isSelected ? AppColors.kBlack : AppColors.kWhite,
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
        ],
      ),
    ),
  );
}

Widget _buildStatusChip(String label,Color color1,Color color2) {
  return OutlinedButton(
    onPressed: () {},
    style: OutlinedButton.styleFrom(
      backgroundColor: color1,
      side: BorderSide(color: color1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Get.width * 0.02),
      ),
      padding:
          EdgeInsets.symmetric(horizontal: Get.width * 0.03, vertical: Get.width * 0.01),
    ),
    child: Text(label,
        style: AppTypography.kLight14.copyWith(color: color2)),
  );
}


}
