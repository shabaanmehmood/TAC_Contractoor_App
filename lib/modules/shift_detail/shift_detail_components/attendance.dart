import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taccontractor/data/data/constants/app_assets.dart';
import 'package:taccontractor/data/data/constants/app_colors.dart';
import 'package:taccontractor/data/data/constants/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

Widget buildShiftUserCard({
  required String name,
  required String role,
  required String inTime,
  required String outTime,
  required int hours,
  required int rate,
  required bool hasProof,
}) {
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
        /// Profile Row
        Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(Get.width * 0.02),
              child: Image.asset(
                'assets/userpicture.jpg',
                width: Get.width * 0.16,
                height: Get.width * 0.16,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: Get.width * 0.04),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: AppTypography.kBold18.copyWith(
                      color: AppColors.kWhite,
                    ),
                  ),
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: Get.width * 0.02,
                          vertical: Get.width * 0.01,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.kACardAlert.withOpacity(0.4),
                          borderRadius: BorderRadius.circular(Get.width * 0.02),
                        ),
                        child: Row(
                          children: [
                            Image.asset(
                              "assets/icon/Layer 2.png",
                              width: Get.width * 0.04,
                            ),
                            SizedBox(width: Get.width * 0.01),
                            Text(
                              role,
                              style: AppTypography.kBold12.copyWith(
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: Get.height * 0.005),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: Get.height * 0.02),

        /// Shift Info Row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(inTime,
                    style: AppTypography.kBold16.copyWith(color: AppColors.kWhite)),
                Text("Clocked In",
                    style: AppTypography.kLight14.copyWith(color: AppColors.kgrey)),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(outTime,
                    style: AppTypography.kBold16.copyWith(color: AppColors.kWhite)),
                Text("Clocked Out",
                    style: AppTypography.kLight14.copyWith(color: AppColors.kgrey)),
              ],
            ),
          ],
        ),

        SizedBox(height: Get.height * 0.015),

        /// Hours and Earning
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("$hours * \$$rate",
                    style: AppTypography.kBold14.copyWith(color: AppColors.kWhite)),
                Text("Hours Worked",
                    style: AppTypography.kLight14.copyWith(color: AppColors.kgrey)),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text("${hours * rate}",
                    style: AppTypography.kBold14.copyWith(color: AppColors.kWhite)),
                Text("Shift Earning",
                    style: AppTypography.kLight14.copyWith(color: AppColors.kgrey)),
              ],
            )
          ],
        ),

        SizedBox(height: Get.height * 0.015),

        /// Selfie Proof
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Clock in Selfie Proof",
                    style: AppTypography.kBold14.copyWith(color: AppColors.kWhite)),
                if (hasProof)
                  Text("Approved",
                      style: AppTypography.kLight12.copyWith(color: AppColors.kgrey)),
              ],
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(Get.width * 0.02),
              child: Image.asset(
                'assets/userpicture.jpg',
                width: Get.width * 0.12,
                height: Get.width * 0.1,
                fit: BoxFit.cover,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
