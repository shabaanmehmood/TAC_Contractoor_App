import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taccontractor/data/data/constants/app_assets.dart';
import 'package:taccontractor/data/data/constants/app_colors.dart';
import 'package:taccontractor/data/data/constants/app_typography.dart';
import 'package:intl/intl.dart';

Widget buildInProgressShiftUserCard({
  required String name,
  required String role,
  required String inTime,
  required String outTime,
  required int hours,
  required int rate,
  required bool hasProof,
  String status = "APPROVAL AWAITING",
  String timer = "28:10",
  bool isClockedIn = true,
}) {
  return Container(
    margin: EdgeInsets.only(bottom: Get.height * 0.015),
    padding: EdgeInsets.all(Get.width * 0.04),
    decoration: BoxDecoration(
      color: AppColors.kinput.withOpacity(0.5),
      borderRadius: BorderRadius.circular(Get.width * 0.02),
      border: Border.all(width: 1, color: AppColors.kinput),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Top Row - Profile + Status
        Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(Get.width * 0.02),
              child: Image.asset(
                'assets/userpicture.jpg',
                width: Get.width * 0.13,
                height: Get.width * 0.13,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: Get.width * 0.03),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: AppTypography.kBold16.copyWith(
                      color: AppColors.kWhite,
                    ),
                  ),
                  if (status == "ON DUTY")
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
          if (status.isNotEmpty)
  if (status == "CLOCK IN AWAITING")
    Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          children: [
            Image.asset(
              "assets/icon/timer.png",
              scale: Get.width * 0.0025,
              color: AppColors.kblueCard,
            ),
            SizedBox(width: 6),
            Text(timer,
                style: AppTypography.kBold14
                    .copyWith(color: AppColors.kblueCard)),
          ],
        ),
        SizedBox(height: 4),
        Text(
          "Clock In Awaiting",
          style: AppTypography.kLight12.copyWith(color: AppColors.kgrey),
        ),
      ],
    )
  else
    Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        GestureDetector(
          onTap: () {},
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: status == "ON DUTY"
                  ? AppColors.kGreenS.withOpacity(0.3)
                  : AppColors.kInProgressCard.withOpacity(0.3),
              borderRadius: BorderRadius.circular(Get.width * 0.02),
            ),
            child: Center(
              child: Text(
                status,
                style: AppTypography.kBold12.copyWith(
                  color: status == "ON DUTY"
                      ? AppColors.kgreen
                      : AppColors.kInProgressCard,
                ),
              ),
            ),
          ),
        ),
        if (status == "APPROVAL AWAITING") ...[
          SizedBox(height: 6),
          Row(
            children: [
              Image.asset(
                "assets/icon/timer.png",
                scale: Get.width * 0.0025,
                color: AppColors.kInProgressCard,
              ),
              SizedBox(width: 6),
              Text(timer,
                  style: AppTypography.kBold14
                      .copyWith(color: AppColors.kInProgressCard)),
            ],
          ),
        ],
      ],
    ),

          ],
        ),

        /// Progress Bar
        SizedBox(height: Get.height * 0.015),
        if (status == "APPROVAL AWAITING") ...[
          SizedBox(height: Get.height * 0.015),
          Container(
            height: Get.height * 0.008,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.kInProgressCard.withOpacity(0.3),
              borderRadius: BorderRadius.circular(Get.width * 0.015),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: 0.4,
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.kInProgressCard,
                  borderRadius: BorderRadius.circular(Get.width * 0.015),
                ),
              ),
            ),
          ),
        ],

        

        SizedBox(height: Get.height * 0.015),

        /// Time Info Row
        if (isClockedIn)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(inTime,
                    style: AppTypography.kBold14.copyWith(color: AppColors.kWhite)),
                Text("Clocked In",
                    style: AppTypography.kLight12.copyWith(color: AppColors.kgrey)),
              ]),
              Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                Text(outTime,
                    style: AppTypography.kBold14.copyWith(color: AppColors.kWhite)),
                Text("Clocked Out",
                    style: AppTypography.kLight12.copyWith(color: AppColors.kgrey)),
              ]),
            ],
          ),

        SizedBox(height: Get.height * 0.015),

        /// Selfie Proof
        if (isClockedIn)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text("Clock In Selfie Proof",
                    style: AppTypography.kBold14.copyWith(color: AppColors.kWhite)),
                Text(
                  hasProof ? "Waiting" : "Not Uploaded",
                  style: AppTypography.kLight12.copyWith(color: AppColors.kgrey),
                ),
              ]),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  'assets/userpicture.jpg',
                  width: Get.width * 0.12,
                  height: Get.width * 0.12,
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
      ],
    ),
  );
}
