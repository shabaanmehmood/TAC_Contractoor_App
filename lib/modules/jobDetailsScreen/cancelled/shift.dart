import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taccontractor/data/data/constants/app_colors.dart';
import 'package:taccontractor/data/data/constants/app_typography.dart';

import '../../../models/myJobs_model.dart';

Widget cancelledShiftCard(MyjobsModel job) {
  return ListView.builder(
    itemCount: job.shifts.length,
    padding: EdgeInsets.symmetric(vertical: Get.height * 0.02),
    itemBuilder: (context, index) {
      final shift = job.shifts[index];
      return Container(
        margin: EdgeInsets.symmetric(horizontal: Get.width * 0.04, vertical: Get.height * 0.01),
        padding: EdgeInsets.all(Get.width * 0.035),
        decoration: BoxDecoration(
          border: Border.all(width: Get.width * 0.002, color: AppColors.kWhite.withOpacity(0.5)),
          color: AppColors.kinput.withOpacity(0.5),
          borderRadius: BorderRadius.circular(Get.width * 0.02),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row: Shift Days + Status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  shift.days.join(', '),
                  style: AppTypography.kBold16.copyWith(color: AppColors.kWhite),
                ),
                Text(
                  job.jobStatus?.toUpperCase() ?? '',
                  style: AppTypography.kBold12.copyWith(color: AppColors.kblueCard),
                ),
              ],
            ),
            SizedBox(height: Get.height * 0.01),
            // Time Row
            Row(
              children: [
                Image.asset("assets/icon/time.png", scale: Get.width * 0.0025, color: AppColors.kgrey),
                SizedBox(width: Get.width * 0.02),
                Text(
                  "${shift.startTime} - ${shift.endTime}",
                  style: AppTypography.kLight14.copyWith(color: AppColors.kgrey),
                ),
              ],
            ),
            SizedBox(height: Get.height * 0.015),

            /// Name & Phone Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(job.contractorName,
                    style: AppTypography.kBold14
                        .copyWith(color: AppColors.kWhite)),
                Row(
                  children: [
                    Icon(Icons.call,
                        size: Get.width * 0.05, color: AppColors.kgrey),
                    SizedBox(width: Get.width * 0.01),
                    Text("+61 2 1234 5678",
                        style: AppTypography.kLight12
                            .copyWith(color: AppColors.kgrey)),
                  ],
                ),
              ],
            ),
            SizedBox(height: Get.height * 0.015),

            /// Avatars and Arrow Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 15,
                          backgroundColor: Colors.transparent,
                          child: ClipOval(
                            child: Image.asset(
                              "assets/userpicture.jpg",
                              width: 30,
                              height: 30,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: Get.width * 0.04),
                          child: CircleAvatar(
                            radius: 15,
                            backgroundColor: Colors.transparent,
                            child: ClipOval(
                              child: Image.asset(
                                "assets/userpicture.jpg",
                                width: 30,
                                height: 30,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: Get.width * 0.08),
                          child: CircleAvatar(
                            radius: 15,
                            backgroundColor: Colors.transparent,
                            child: ClipOval(
                              child: Image.asset(
                                "assets/userpicture.jpg",
                                width: 30,
                                height: 30,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                Icon(Icons.keyboard_arrow_down_rounded,
                    color: AppColors.kblueCard, size: Get.width * 0.07),
              ],
            ),
          ],
        ),
      );
    },
  );}
