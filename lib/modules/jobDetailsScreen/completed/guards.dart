import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taccontractor/data/data/constants/app_colors.dart';
import 'package:taccontractor/data/data/constants/app_typography.dart';
import 'package:taccontractor/modules/jobDetailsScreen/completed/guardProfile.dart';

Widget completedGuards() {
  return SizedBox(
    height: Get.height * 0.8,
    child: ListView.builder(
      itemCount: 10,
      padding: EdgeInsets.symmetric(vertical: Get.height * 0.02),
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>CompletedGuardProfileScreen()));
          },
          child: Padding(
            padding: EdgeInsets.only(
              left: Get.width * 0.04,
              right: Get.width * 0.04,
              bottom: Get.height * 0.015,
            ),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                horizontal: Get.width * 0.04,
                vertical: Get.width * 0.03,
              ),
              decoration: BoxDecoration(
                color: AppColors.kinput.withOpacity(0.5),
                borderRadius: BorderRadius.circular(Get.width * 0.02),
              ),
              child: Row(
                children: [
                  // Profile Image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(Get.width * 0.02),
                    child: Image.asset(
                      'assets/userpicture.jpg',
                      width: Get.width * 0.18,
                      height: Get.width * 0.18,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(width: Get.width * 0.03),
          
                  // Right content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Badge and verified icon
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: Get.width * 0.02,
                                vertical: Get.width * 0.01,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.kGuardsCard,
                                borderRadius: BorderRadius.circular(Get.width * 0.02),
                              ),
                              child: Row(
                                children: [
                                  Image.asset(
                                    "assets/icon/Layer 2.png",
                                    width: Get.width * 0.035,
                                  ),
                                  SizedBox(width: Get.width * 0.01),
                                  Text(
                                    'Leader Guard',
                                    style: AppTypography.kBold10.copyWith(
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: Get.width * 0.015),
                            CircleAvatar(
                              radius: Get.width * 0.03,
                              backgroundColor: AppColors.kGuardsCard,
                              child: Icon(
                                Icons.verified,
                                size: Get.width * 0.04,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: Get.height * 0.005),
          
                        // Name
                        Text(
                          'Johsan Bill',
                          style: AppTypography.kBold18.copyWith(
                            color: AppColors.kWhite,
                          ),
                        ),
                        SizedBox(height: Get.height * 0.003),
          
                        // Level & Rating
                        Row(
                          children: [
                            Text(
                              'Level 2',
                              style: AppTypography.kLight12.copyWith(
                                color: Colors.grey.shade400,
                              ),
                            ),
                            SizedBox(width: Get.width * 0.02),
                            Icon(
                              Icons.star,
                              size: Get.width * 0.06,
                              color: Colors.cyanAccent,
                            ),
                            SizedBox(width: Get.width * 0.01),
                            Text(
                              '5.0',
                              style: AppTypography.kBold12.copyWith(
                                color: AppColors.kWhite,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    ),
  );
}
