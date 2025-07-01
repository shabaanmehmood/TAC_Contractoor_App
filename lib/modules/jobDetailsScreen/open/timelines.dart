import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taccontractor/data/data/constants/app_colors.dart';
import 'package:taccontractor/data/data/constants/app_typography.dart';

Widget openTimeline() {
  return Column(
    children: [
      SizedBox(height: Get.height * 0.015),
      Container(
        margin: EdgeInsets.symmetric(horizontal: Get.height * 0.02),
        padding: EdgeInsets.symmetric(
          horizontal: Get.width * 0.03,
          vertical: Get.width * 0.01,
        ),
        decoration: BoxDecoration(
          color: AppColors.kinput.withOpacity(0.5),
          borderRadius: BorderRadius.circular(Get.width * 0.01),
        ),
        width: double.infinity,

        // ✅ Give ListView a bounded height using SizedBox
        child: SizedBox(
          height: Get.height * 0.4, // Adjust height as needed
          child: ListView.builder(
            itemCount: 10,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: Get.width * 0.007,
                          backgroundColor: AppColors.kSkyBlue,
                        ),
                        SizedBox(width: Get.width * 0.02),
                        Text(
                          '"John Max" Hired!',
                          style: AppTypography.kLight16.copyWith(
                            color: AppColors.kWhite.withOpacity(0.8),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      '22 Mar 25 - 9:00 PM',
                      style: AppTypography.kLight14.copyWith(
                        color: AppColors.kgrey,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    ],
  );
}
