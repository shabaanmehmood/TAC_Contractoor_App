import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:taccontractor/data/data/constants/app_assets.dart';
import 'package:taccontractor/data/data/constants/app_colors.dart';
import 'package:taccontractor/data/data/constants/app_spacing.dart';
import 'package:taccontractor/data/data/constants/app_typography.dart';
import 'package:taccontractor/modules/myJobs/myJobsComponent.dart/active.dart';
import 'package:taccontractor/modules/myJobs/myJobsComponent.dart/cancelled.dart';
import 'package:taccontractor/modules/myJobs/myJobsComponent.dart/completed.dart';
import 'package:taccontractor/modules/myJobs/myJobsComponent.dart/inProgress.dart';
import 'package:taccontractor/modules/myJobs/myJobsComponent.dart/open.dart';


class MyJobsScreen extends StatefulWidget {
  @override
  State<MyJobsScreen> createState() => _MyJobsScreenState();
}

class _MyJobsScreenState extends State<MyJobsScreen> {
  final List<String> tabs = ["Open", "Active", "In Progress", "Completed", "Cancelled"];
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColors.kDarkBlue,
      body: Padding(
        padding: EdgeInsets.only(
          right: Get.height * 0.02,
          top: Get.height * 0.06,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Top Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Image.asset(
                      AppAssets.kTacLogo,
                      height: Get.height * 0.05,
                      width: Get.width * 0.2,
                      fit: BoxFit.contain,
                    ),
                    Text(
                      "My Jobs",
                      style: AppTypography.kBold24.copyWith(color: AppColors.kWhite),
                    ),
                  ],
                ),
               Image.asset("assets/icon/plus.png",scale: Get.width * 0.003,color: AppColors.kSkyBlue),
            
                // Icon(
                //   Icons.add,
                //   color: AppColors.kSkyBlue,
                //   size: Get.width * 0.08,
                // )
              ],
            ),

            /// Search Bar
            Container(
              margin: EdgeInsets.only(
                  left: Get.width * 0.04,
                  top: Get.width * 0.04,
                  bottom: Get.width * 0.04),
              child: TextFormField(
                style: const TextStyle(color: AppColors.kgrey),
                decoration: InputDecoration(
                  fillColor: AppColors.kDarkBlue,
                  filled: true,
                  hintText: "Search for security jobs...",

                  // suffixIcon: Icon(Icons.search, color: AppColors.kgrey, size: Get.width * 0.06),
                  suffixIcon: Image.asset("assets/icon/search.png",scale: Get.width * 0.004,),
                  hintStyle: TextStyle(color: AppColors.kgrey, fontSize: 16),
                  contentPadding: EdgeInsets.symmetric(
                    vertical: Get.width * 0.03,
                    horizontal: Get.width * 0.04,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(Get.width * 0.04),
                    borderSide: const BorderSide(width: 0.8, color: AppColors.kgrey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(Get.width * 0.09),
                    borderSide: const BorderSide(width: 0.04, color: AppColors.kgrey),
                  ),
                ),
              ),
            ),

            /// Tab Buttons
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Padding(
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
                          backgroundColor: isSelected ? AppColors.kSkyBlue : Colors.transparent,
                          side: BorderSide(color: AppColors.kSkyBlue),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(Get.width * 0.02),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: Get.width * 0.03, vertical: Get.width * 0.01),
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
            ),

            SizedBox(height: Get.height * 0.02),

            /// Job Card Widget
           Expanded(
  child: ListView.builder(
    padding: EdgeInsets.zero,
    itemCount: 2,
    itemBuilder: (context, index) {
      Widget selectedCard;

      switch (selectedIndex) {
        case 0:
          selectedCard = jobOpenCardWidget();
          break;
        case 1:
          selectedCard = jobActiveCardWidget();
          break;
        case 2:
          selectedCard = jobInProgressCardWidget();
          break;
        case 3:
          selectedCard = jobCompletedCardWidget();
          break;
        case 4:
          selectedCard = jobCancelledCardWidget();
          break;
        default:
          selectedCard = jobOpenCardWidget();
      }

      return Column(
        children: [
          selectedCard,
          SizedBox(height: Get.height * 0.02),
        ],
      );
    },
  ),
),


          ],
        ),
      ),
    );
  }


 
}
