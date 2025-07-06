import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taccontractor/data/data/constants/app_colors.dart';
import 'package:taccontractor/data/data/constants/app_typography.dart';

Widget buildNotesCard() {
  return Container(
    margin: EdgeInsets.only(bottom: Get.height * 0.015),
    padding: EdgeInsets.all(Get.width * 0.04),
    decoration: BoxDecoration(
      border: Border.all(
        width: Get.width * 0.001,
        color: AppColors.kgrey.withOpacity(0.5),
      ),
      color: AppColors.kgrey.withOpacity(0.1),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Note text
        Text(
          "Things are good right now.",
          style: AppTypography.kBold14.copyWith(color: AppColors.kgrey),
        ),

        // SizedBox(height: Get.height * 0.003),

        /// Row with time and avatar
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            /// Time
            Text(
              "9:00 AM",
              style: AppTypography.kLight12.copyWith(color: AppColors.kgrey),
            ),

            /// Rounded avatar
            CircleAvatar(
              radius: Get.width * 0.04,
              backgroundImage: AssetImage('assets/userpicture.jpg'),
              backgroundColor: Colors.transparent,
            ),
          ],
        ),
      ],
    ),
  );
}
