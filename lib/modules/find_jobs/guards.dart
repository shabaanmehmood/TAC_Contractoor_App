// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:get/get.dart';
// import 'package:taccontractor/data/data/constants/app_assets.dart';
// import 'package:taccontractor/data/data/constants/app_colors.dart';
// import 'package:taccontractor/data/data/constants/app_typography.dart';
// import 'package:taccontractor/modules/find_jobs/components/all.dart';
// import 'package:taccontractor/modules/find_jobs/components/all_archive.dart';
// import 'package:taccontractor/modules/find_jobs/components/notification.dart';

// class AvailableGuardsScreen extends StatefulWidget {
//   @override
//   State<AvailableGuardsScreen> createState() => _AvailableGuardsScreenState();
// }

// class _AvailableGuardsScreenState extends State<AvailableGuardsScreen> {
//   final List<String> tabs = ["All", "Armed", "Event", "Corporate"];
//   int selectedIndex = 0;

//   bool showArchive = false;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.kDarkBlue,
//       body: SafeArea(
//         child: Padding(
//           padding: EdgeInsets.symmetric(
//               vertical: Get.width * 0.04, horizontal: Get.width * 0.04),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               /// Top Row
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Row(
//                     children: [
//                       Image.asset(
//                         AppAssets.kTacLogo,
//                         height: Get.height * 0.05,
//                         width: Get.width * 0.2,
//                         fit: BoxFit.contain,
//                       ),
//                       SizedBox(width: 8),
//                       Text(
//                         "Guards",
//                         style: AppTypography.kBold24
//                             .copyWith(color: AppColors.kWhite),
//                       ),
//                     ],
//                   ),
//                   Row(
//                     children: [
//                       GestureDetector(
//                         onTap: () {
//                           Get.to(NotificationsScreen());
//                         },
//                         child: SvgPicture.asset(
//                           "assets/icon/notification.svg",
//                           width: 24,
//                           color: AppColors.kSkyBlue,
//                         ),
//                       ),
//                       SizedBox(width: 10),
//                       Image.asset(
//                         "assets/icon/plus.png",
//                         width: 24,
//                         color: AppColors.kSkyBlue,
//                       ),
//                     ],
//                   ),
//                 ],
//               ),

//               SizedBox(height: Get.height * 0.02),

//               /// Search Row + Toggle Icon
//               Row(
//                 children: [
//                   Expanded(
//                     child: TextFormField(
//                       style: const TextStyle(color: AppColors.kgrey),
//                       decoration: InputDecoration(
//                         hintText: "Search for security jobs...",
//                         hintStyle:
//                             TextStyle(color: AppColors.kgrey, fontSize: 16),
//                         fillColor: AppColors.kDarkBlue,
//                         filled: true,
//                         suffixIcon: Padding(
//                           padding: const EdgeInsets.all(10.0),
//                           child: Image.asset("assets/icon/search.png"),
//                         ),
//                         contentPadding: EdgeInsets.symmetric(
//                           vertical: Get.width * 0.03,
//                           horizontal: Get.width * 0.04,
//                         ),
//                         enabledBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(Get.width * 0.04),
//                           borderSide: const BorderSide(
//                               width: 0.8, color: AppColors.kgrey),
//                         ),
//                         focusedBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(Get.width * 0.09),
//                           borderSide: const BorderSide(
//                               width: 0.04, color: AppColors.kgrey),
//                         ),
//                       ),
//                     ),
//                   ),
//                   SizedBox(width: 10),

//                   /// Toggle Archive Icon
//                   GestureDetector(
//                     onTap: () {
//                       setState(() {
//                         showArchive = !showArchive;
//                       });
//                     },
//                     child: Image.asset(
//                       showArchive
//                           ? "assets/icon/archieve.png"
//                           : "assets/icon/save.png",
//                       width: 24,
//                       color: AppColors.kSkyBlue,
//                     ),
//                   ),
//                 ],
//               ),

//               SizedBox(height: 10),

//               /// Section Title
//               Text(
//                 showArchive ? "Archived Guards" : "Available Guards",
//                 style:
//                     AppTypography.kBold20.copyWith(color: AppColors.kWhite),
//               ),

//               SizedBox(height: 10),

//               /// Tab Buttons
//               SingleChildScrollView(
//                 scrollDirection: Axis.horizontal,
//                 child: Row(
//                   children: List.generate(tabs.length, (index) {
//                     final isSelected = selectedIndex == index;
//                     return Padding(
//                       padding: EdgeInsets.only(right: Get.width * 0.02),
//                       child: OutlinedButton(
//                         onPressed: () {
//                           setState(() {
//                             selectedIndex = index;
//                           });
//                         },
//                         style: OutlinedButton.styleFrom(
//                           backgroundColor: isSelected
//                               ? AppColors.kSkyBlue
//                               : Colors.transparent,
//                           side: BorderSide(color: AppColors.kSkyBlue),
//                           shape: RoundedRectangleBorder(
//                             borderRadius:
//                                 BorderRadius.circular(Get.width * 0.02),
//                           ),
//                           padding: EdgeInsets.symmetric(
//                             horizontal: Get.width * 0.03,
//                             vertical: Get.width * 0.01,
//                           ),
//                         ),
//                         child: Text(
//                           tabs[index],
//                           style: AppTypography.kBold16.copyWith(
//                             color: isSelected
//                                 ? AppColors.kBlack
//                                 : AppColors.kWhite,
//                           ),
//                         ),
//                       ),
//                     );
//                   }),
//                 ),
//               ),

//               SizedBox(height: 10),

//               /// Job List (Toggle between AllGuards and AllArchieveGuards)
//               Expanded(
//                 child: showArchive ? AllArchieveGuards() : AllGuards(),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:taccontractor/data/data/constants/app_assets.dart';
import 'package:taccontractor/data/data/constants/app_colors.dart';
import 'package:taccontractor/data/data/constants/app_typography.dart';
import 'package:taccontractor/modules/find_jobs/components/all.dart';
import 'package:taccontractor/modules/find_jobs/components/all_archive.dart';
import 'package:taccontractor/modules/find_jobs/components/notification.dart';

class AvailableGuardsScreen extends StatefulWidget {
  @override
  State<AvailableGuardsScreen> createState() => _AvailableGuardsScreenState();
}

class _AvailableGuardsScreenState extends State<AvailableGuardsScreen> {
  final List<String> tabs = ["All", "Armed", "Event", "Corporate"];
  int selectedIndex = 0;
  bool showArchive = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kDarkBlue,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
              vertical: Get.width * 0.04, horizontal: Get.width * 0.04),
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
                      SizedBox(width: 8),
                      Text(
                        "Guards",
                        style: AppTypography.kBold24
                            .copyWith(color: AppColors.kWhite),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Get.to(NotificationsScreen());
                        },
                        child: SvgPicture.asset(
                          "assets/icon/notification.svg",
                          width: 24,
                          color: AppColors.kSkyBlue,
                        ),
                      ),
                      SizedBox(width: 10),
                      Image.asset(
                        "assets/icon/plus.png",
                        width: 24,
                        color: AppColors.kSkyBlue,
                      ),
                    ],
                  ),
                ],
              ),

              SizedBox(height: Get.height * 0.02),

              /// Search + Archive Toggle
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      style: const TextStyle(color: AppColors.kgrey),
                      decoration: InputDecoration(
                        hintText: "Search for security jobs...",
                        hintStyle:
                            TextStyle(color: AppColors.kgrey, fontSize: 16),
                        fillColor: AppColors.kDarkBlue,
                        filled: true,
                        suffixIcon: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Image.asset("assets/icon/search.png"),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          vertical: Get.width * 0.03,
                          horizontal: Get.width * 0.04,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(Get.width * 0.04),
                          borderSide: const BorderSide(
                              width: 0.8, color: AppColors.kgrey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(Get.width * 0.09),
                          borderSide: const BorderSide(
                              width: 0.04, color: AppColors.kgrey),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        showArchive = !showArchive;
                      });
                      
                    },
                    child: Image.asset(
                      showArchive
                          ? "assets/icon/archieve.png"
                          : "assets/icon/save.png",
                      width: 24,
                      color: AppColors.kSkyBlue,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 10),

              Text(
                showArchive ? "Archived Guards" : "Available Guards",
                style:
                    AppTypography.kBold20.copyWith(color: AppColors.kWhite),
              ),

              SizedBox(height: 10),

              /// Tabs
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(tabs.length, (index) {
                    final isSelected = selectedIndex == index;
                    return Padding(
                      padding: EdgeInsets.only(right: Get.width * 0.02),
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
                            borderRadius:
                                BorderRadius.circular(Get.width * 0.02),
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: Get.width * 0.03,
                            vertical: Get.width * 0.01,
                          ),
                        ),
                        child: Text(
                          tabs[index],
                          style: AppTypography.kBold16.copyWith(
                            color: isSelected
                                ? AppColors.kBlack
                                : AppColors.kWhite,
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),

              SizedBox(height: 10),

              /// Guard List
              Expanded(
                child: showArchive
                    ? AllArchieveGuards(type: tabs[selectedIndex])
                    : FilteredGuards(type: tabs[selectedIndex]),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 