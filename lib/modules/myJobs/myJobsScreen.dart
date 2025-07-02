import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:taccontractor/data/data/constants/app_assets.dart';
import 'package:taccontractor/data/data/constants/app_colors.dart';
import 'package:taccontractor/data/data/constants/app_spacing.dart';
import 'package:taccontractor/data/data/constants/app_typography.dart';
import 'package:taccontractor/dataproviders/api_service.dart';
import 'package:taccontractor/modules/Jobs/Create%20Jobs/setJobDetailsScreen.dart';
import 'package:taccontractor/modules/myJobs/myJobsComponent.dart/active.dart';
import 'package:taccontractor/modules/myJobs/myJobsComponent.dart/cancelled.dart';
import 'package:taccontractor/modules/myJobs/myJobsComponent.dart/completed.dart';
import 'package:taccontractor/modules/myJobs/myJobsComponent.dart/inProgress.dart';
import 'package:taccontractor/modules/myJobs/myJobsComponent.dart/open.dart';
import 'package:taccontractor/models/myJobs_model.dart';

import 'myJobsController.dart';


class MyJobsScreen extends StatefulWidget {
  @override
  State<MyJobsScreen> createState() => _MyJobsScreenState();
}

class _MyJobsScreenState extends State<MyJobsScreen> {
  MyApIService myApiService = MyApIService();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // fetchMyJobs();
  }

  // Future<void> fetchMyJobs() async {
  //   try {
  //     final response = await myApiService.getMyJobs();
  //     if (response.statusCode == 200) {
  //       final Map<String, dynamic> jsonMap = jsonDecode(response.body);
  //       final List<dynamic> jsonList = jsonMap['data'];
  //       List<MyjobsModel> myJobs = jsonList.map((json) => MyjobsModel.fromJson(json)).toList();
  //     }
  //   } catch (e) {
  //     Get.snackbar("Error", "Failed to fetch licenses");
  //   }
  // }

  final List<String> tabs = ["Open", "Active", "In Progress", "Completed", "Cancelled"];
  int selectedIndex = 0;
  final MyJobsController controller = Get.put(MyJobsController());


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
               GestureDetector(
                 onTap: () => Get.to(() => SetJobDetailsScreen()),
                   child: Image.asset("assets/icon/plus.png",scale: Get.width * 0.003,color: AppColors.kSkyBlue)),
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

            // /// Tab Buttons
            // SingleChildScrollView(
            //   scrollDirection: Axis.horizontal,
            //   child: Padding(
            //     padding: EdgeInsets.only(left: Get.width * 0.03),
            //     child: Row(
            //       children: List.generate(tabs.length, (index) {
            //         final isSelected = selectedIndex == index;
            //         return Padding(
            //           padding: EdgeInsets.symmetric(horizontal: Get.width * 0.015),
            //           child: OutlinedButton(
            //             onPressed: () {
            //               setState(() {
            //                 selectedIndex = index;
            //               });
            //             },
            //             style: OutlinedButton.styleFrom(
            //               backgroundColor: isSelected ? AppColors.kSkyBlue : Colors.transparent,
            //               side: BorderSide(color: AppColors.kSkyBlue),
            //               shape: RoundedRectangleBorder(
            //                 borderRadius: BorderRadius.circular(Get.width * 0.02),
            //               ),
            //               padding: EdgeInsets.symmetric(horizontal: Get.width * 0.03, vertical: Get.width * 0.01),
            //             ),
            //             child: Text(
            //               tabs[index],
            //               style: AppTypography.kBold16.copyWith(
            //                 color: isSelected ? AppColors.kBlack : AppColors.kWhite,
            //               ),
            //             ),
            //           ),
            //         );
            //       }),
            //     ),
            //   ),
            // ),

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
            // SizedBox(height: Get.height * 0.02),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return Center(child: CircularProgressIndicator());
                }
                List<MyjobsModel> filteredJobs = [];
                switch (selectedIndex) {
                  case 0:
                    filteredJobs = controller.getJobsByStatus("open");
                    break;
                  case 1:
                    filteredJobs = controller.getJobsByStatus("active");
                    break;
                  case 2:
                    filteredJobs = controller.getJobsByStatus("in_progress");
                    break;
                  case 3:
                    filteredJobs = controller.getJobsByStatus("completed");
                    break;
                  case 4:
                    filteredJobs = controller.getJobsByStatus("cancelled");
                    break;
                  default:
                    filteredJobs = controller.getJobsByStatus("open");
                }
                return ListView.separated(
                  separatorBuilder: (context, index) => SizedBox(height: Get.height * 0.02),
                  itemCount: filteredJobs.length,
                  itemBuilder: (context, index) {
                    final job = filteredJobs[index];
                    switch (selectedIndex) {
                      case 0:
                        return jobOpenCardWidget(job: job);
                      case 1:
                        return jobActiveCardWidget(job: job);
                      case 2:
                        return jobInProgressCardWidget(job: job);
                      case 3:
                        return jobCompletedCardWidget(job: job);
                      case 4:
                        return jobCancelledCardWidget(job: job);
                      default:
                        return jobOpenCardWidget(job: job);
                    }
                  },
                );
              }),
            ),


//             /// Job Card Widget
//            Expanded(
//   child: ListView.builder(
//     padding: EdgeInsets.zero,
//     itemCount: 2,
//     itemBuilder: (context, index) {
//       Widget selectedCard;
//
//       switch (selectedIndex) {
//         case 0:
//           selectedCard = jobOpenCardWidget();
//           break;
//         case 1:
//           selectedCard = jobActiveCardWidget();
//           break;
//         case 2:
//           selectedCard = jobInProgressCardWidget();
//           break;
//         case 3:
//           selectedCard = jobCompletedCardWidget();
//           break;
//         case 4:
//           selectedCard = jobCancelledCardWidget();
//           break;
//         default:
//           selectedCard = jobOpenCardWidget();
//       }
//
//       return Column(
//         children: [
//           selectedCard,
//           SizedBox(height: Get.height * 0.02),
//         ],
//       );
//     },
//   ),
// ),


          ],
        ),
      ),
    );
  }


 
}
